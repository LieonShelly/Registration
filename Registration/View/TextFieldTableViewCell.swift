//
//  TextFieldTableViewCell.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private lazy var textField: UITextField = {
       let field = UITextField()
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 15)
        field.placeholder = "Please input"
        field.textAlignment = .right
        return field
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
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(6)
        }
    }
    
    func config(title: String, placeholder: String) {
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
