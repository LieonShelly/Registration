//
//  CenterButtonTableViewCell.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/15.
//

import UIKit
import Combine

class CenterButtonTableViewCell: UITableViewCell {
    var bag: Set<AnyCancellable> = .init()
    private(set) lazy var btn: UIButton = {
       let btn = UIButton()
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.isEnabled = false
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
    private var btnDidClick: (() -> Void)?
    
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
    
    func config(title: String, btnDidClick: (() -> Void)?) {
        self.btn.setTitle(title, for: .normal)
        self.btnDidClick = btnDidClick
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
