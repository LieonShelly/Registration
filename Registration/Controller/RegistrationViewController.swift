//
//  RegistrationViewController.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import UIKit
import SnapKit
import Combine
import PhotosUI

class RegistrationInfo: NSObject {
    
}

class RegistrationViewController: UIViewController {
    private var bag: Set<AnyCancellable> = .init()
    private lazy var tableview: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        return view
    }()
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = makeDataSource()
    private var viewmModel: RegistrationViewModel
    
    
    init(viewModel: RegistrationViewModel) {
        self.viewmModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.configBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        title = "Registration"
        view.backgroundColor = .white
        view.addSubview(tableview)
        tableview.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        tableview.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldTableViewCell")
        tableview.register(AvatarTableViewCell.self, forCellReuseIdentifier: "AvatarTableViewCell")
        tableview.register(CenterButtonTableViewCell.self, forCellReuseIdentifier: "CenterButtonTableViewCell")
        tableview.register(RightBtnTableViewCell.self, forCellReuseIdentifier: "RightBtnTableViewCell")
        tableview.delegate = self
    }
    
    fileprivate func configBinding() {
        viewmModel.avatarSelectObject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] in
                self?.openPhtoPicker()
            })
            .store(in: &bag)
    }
    
    private func openPhtoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        applySnapshot()
    }
   
    func makeDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        return .init(tableView: tableview) {[weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard let self = self else { return nil}
            switch item.cellType {
            case .avatar(let entity):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarTableViewCell", for: indexPath) as? AvatarTableViewCell else {
                    return nil
                }
                cell.config(title: entity.title, btnDidClick: {
                    entity.selectSubject.send()
                })
                viewmModel.avatarValue
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { image in
                        cell.updateAvatar(image)
                    })
                    .store(in: &cell.bag)
                return cell
            case .firstName(let info):
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                cell?.config(title: info.title, placeholder: info.placeHolder)
                return cell
            case .lastName(let info):
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                cell?.config(title: info.title, placeholder: info.placeHolder)
                return cell
            case .phoneNumber(let info):
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                cell?.config(title: info.title, placeholder: info.placeHolder)
                return cell
            case .email(let info):
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                cell?.config(title: info.title, placeholder: info.placeHolder)
                return cell
            case .avatarColor(let info):
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightBtnTableViewCell", for: indexPath) as? RightBtnTableViewCell
                cell?.config(title: info.title, btnTitle: "Please selectw")
                return cell
            case .submitBtn:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CenterButtonTableViewCell", for: indexPath) as? CenterButtonTableViewCell
                cell?.config(title: "Sign Up")
                return cell
            default: return UITableViewCell()
            }
       
        }
    }
    
    func applySnapshot() {
        var snaphot = NSDiffableDataSourceSnapshot<Section, Item>()
        snaphot.appendSections(viewmModel.sections)
        viewmModel.sections.forEach { section in
            snaphot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snaphot)
    }
}

extension RegistrationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionIdentifier(for: indexPath.section)?.sectionType
        switch section {
        case .avatar: return viewmModel.avatarRowH
        case .basicInfo: return viewmModel.basicInfoRowH
        case .submitBtn: return viewmModel.submitRowH
        case .none: return 44
        }
    }
}


extension RegistrationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty, let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] obj, error in
            if let image = obj as? UIImage {
                self?.viewmModel.avatarValue.send(image)
            }
        }
    }
}
