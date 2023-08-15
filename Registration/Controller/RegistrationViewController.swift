//
//  RegistrationViewController.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import UIKit
import SnapKit

class RegistrationInfo: NSObject {
    
}

class RegistrationViewController: UIViewController {
    
    private lazy var tableview: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Section.Item> = makeDataSource()

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
        
        tableview.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        applySnapshot()
    }
   
    func makeDataSource() -> UITableViewDiffableDataSource<Section, Section.Item> {
        return .init(tableView: tableview) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item.cellType {
            case .avatar(let entity):
                let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarTableViewCell", for: indexPath) as? AvatarTableViewCell
                cell?.config(title: entity.title)
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
                cell?.config(title: info.title, placeholder: info.placeHolder)
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
        var snaphot = NSDiffableDataSourceSnapshot<Section, Section.Item>()
        snaphot.appendSections([.avatar])
        snaphot.appendItems([.init(cellType: .avatar(Avatar(filePath: "")))], toSection: .avatar)
        
        snaphot.appendSections([.basicInfo])
        snaphot.appendItems([
            .init(cellType: .firstName(.init(title: "Firt Name"))),
            .init(cellType: .lastName(.init(title: "Last Name"))),
            .init(cellType: .phoneNumber(.init(title: "phone Number"))),
            .init(cellType: .email(.init(title: "Email"))),
            .init(cellType: .avatarColor(.init(title: "Customer Avatar Color")))],
                            toSection: .basicInfo
        )
        
        snaphot.appendSections([.submitBtn])
        snaphot.appendItems([.init(cellType: .submitBtn)], toSection: .submitBtn)
        dataSource.apply(snaphot)
    }
}

extension RegistrationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionIdentifier(for: indexPath.section)
        switch section {
        case .avatar: return 72
        case .basicInfo: return 60
        case .submitBtn: return 100
        case .none:
            return 44
        }
    }
}

