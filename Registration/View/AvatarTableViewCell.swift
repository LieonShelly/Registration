//
//  AvatarTableViewCell.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//


import UIKit
import SnapKit
import Combine

class AvatarTableViewCell: UITableViewCell {
    var bag: Set<AnyCancellable> = .init()
    private var btnDidClick: (() -> Void)?
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var textField: UITextField = {
       let field = UITextField()
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    
    private lazy var avatarView: UIImageView = {
       let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(avatarContainerView)
        avatarContainerView.addSubview(avatarView)
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        avatarContainerView.snp.makeConstraints {
            $0.width.equalTo(avatarContainerView.snp.height)
            $0.centerY.equalToSuperview()
            $0.top.bottom.right.equalToSuperview().inset(4)
        }
        avatarView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 80))
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(6)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.btnAction))
        avatarView.addGestureRecognizer(tap)
    }
    
    func config(title: String, btnDidClick: (() -> Void)? = nil) {
        self.titleLabel.text = title
        self.btnDidClick = btnDidClick
    }
    
    func updateAvatar(_ img: UIImage?) {
        self.avatarView.image = img
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func btnAction() {
        btnDidClick?()
    }
}
