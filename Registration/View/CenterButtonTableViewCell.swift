//
//  CenterButtonTableViewCell.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/15.
//

import UIKit

class CenterButtonTableViewCell: UITableViewCell {
    private lazy var btn: UIButton = {
       let btn = UIButton()
        btn.setTitle("SignUp", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    private lazy var containerView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(btn)
        selectionStyle = .none
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }
        btn.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    func config(title: String) {
        self.btn.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
