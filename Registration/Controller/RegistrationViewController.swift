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

class RegistrationViewController: UIViewController {
    private var bag: Set<AnyCancellable> = .init()
    private lazy var tableview: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldTableViewCell")
        view.register(AvatarTableViewCell.self, forCellReuseIdentifier: "AvatarTableViewCell")
        view.register(CenterButtonTableViewCell.self, forCellReuseIdentifier: "CenterButtonTableViewCell")
        view.register(RightBtnTableViewCell.self, forCellReuseIdentifier: "RightBtnTableViewCell")
        view.delegate = self
        return view
    }()
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = makeDataSource()
    private var viewmModel: RegistrationViewModel
    private lazy var colorPicker: ColorPickerView = {
        let picker = ColorPickerView()
        picker.alpha = 0
        picker.layer.cornerRadius = 10
        picker.layer.masksToBounds = true
        picker.dismissBtn.addTarget(self, action: #selector(self.hideColorView), for: .touchUpInside)
        return picker
    }()
    
    init(viewModel: RegistrationViewModel) {
        self.viewmModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.configBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension RegistrationViewController {
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Item> {
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
                
                viewmModel.colorValue
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { color in
                        cell.updateAvatarBgColor(color)
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
                cell?.config(title: info.title, btnTitle: "Please select", btnDidClick: {
                    info.handleSubject.send(())
                })
                return cell
            case .submitBtn:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CenterButtonTableViewCell", for: indexPath) as? CenterButtonTableViewCell
                cell?.config(title: "Sign Up")
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
    private func configData() {
        var snaphot = NSDiffableDataSourceSnapshot<Section, Item>()
        snaphot.appendSections(viewmModel.sections)
        viewmModel.sections.forEach { section in
            snaphot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snaphot)
        colorPicker.setSliderValue(red: 25, green: 100, blue: 255)
    }
    
    private func configUI() {
        title = "Registration"
        view.backgroundColor = .white
        view.addSubview(tableview)
        view.addSubview(colorPicker)
        tableview.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        colorPicker.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(300)
            $0.bottom.equalTo(-54)
        }
    }
    
    private func configBinding() {
        viewmModel.avatarSelectObject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] in
                self?.openPhtoPicker()
            })
            .store(in: &bag)
        
        viewmModel.selectColor
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] in
                self?.showColorView()
            })
            .store(in: &bag)
        
        colorPicker.colorValueChanged = {[weak self](red, green, blue) in
            guard let self = self else { return }
            self.viewmModel.colorValue.send(UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1))
        }
    }
    
    private func openPhtoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func showColorView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.colorPicker.alpha = 1
        }, completion: nil)
    }
    
    @objc
    private func hideColorView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.colorPicker.alpha = 0
        }, completion: nil)
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
