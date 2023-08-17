//
//  RightBtnTableViewCell.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/15.
//

import UIKit

class RightBtnTableViewCell: UITableViewCell {
    private var btnDidClick: (() -> Void)?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .system)
        rightBtn.setTitle("Please select", for: .normal)
        rightBtn.setTitleColor(UIColor.gray, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.addTarget(self, action: #selector(self.btnAction), for: .touchUpInside)
        return rightBtn
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
        containerView.addSubview(rightBtn)
        
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        rightBtn.snp.makeConstraints {
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
    
    func config(title: String, btnTitle: String, btnDidClick: (() -> Void)? = nil) {
        self.titleLabel.text = title
        self.rightBtn.setTitle(btnTitle, for: .normal)
        self.btnDidClick = btnDidClick
    }
    
    @objc
    private func btnAction() {
        btnDidClick?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
