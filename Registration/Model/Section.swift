//
//  Section.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/15.
//

import Foundation
import UIKit
import Combine

struct Item: Hashable {
    let id: UUID = UUID()
    let cellType: RegistrationFormType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
       return lhs.id == rhs.id
    }
}

enum SectoionType {
    case avatar
    case basicInfo
    case submitBtn
    
}
struct Section: Hashable {
    var sectionType: SectoionType
    var items: [Item]
    
    var id: String {
        switch sectionType {
        case .avatar:
            return "avatar"
        case .basicInfo:
            return "basicInfo"
        case .submitBtn:
            return "submitBtn"
        }
    }
    /*
    var items: [Item] {
        switch self {
        case .avatar:
            return [.init(cellType: .avatar(Avatar(filePath: "")))]
        case .basicInfo:
            return [
                .init(cellType: .firstName(.init(title: "Firt Name"))),
                .init(cellType: .lastName(.init(title: "Last Name"))),
                .init(cellType: .phoneNumber(.init(title: "phone Number"))),
                .init(cellType: .email(.init(title: "Email"))),
                .init(cellType: .avatarColor(.init(title: "Customer Avatar Color")))
            ]
        case .submitBtn:
            return [.init(cellType: .submitBtn)]
        }
    }
    */
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
       return lhs.id == rhs.id
    }
    
}


class Avatar: Hashable {
    static func == (lhs: Avatar, rhs: Avatar) -> Bool {
       return lhs.filePath == rhs.filePath
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(filePath)
    }
    
    var filePath: String
    var title: String = "Avatar"
    let selectSubject: PassthroughSubject<Void, Never>
    let currentImage: CurrentValueSubject<UIImage?, Never>
    
    init(
        filePath: String,
        selectSubject: PassthroughSubject<Void, Never>,
        currentImage: CurrentValueSubject<UIImage?, Never>
    ) {
        self.filePath = filePath
        self.selectSubject = selectSubject
        self.currentImage = currentImage
    }
}

class BasicInfo: Identfier {
    var title: String
    var content: String = ""
    var placeHolder: String = "Please input"
    var handleSubject: PassthroughSubject<Void, Never> = .init()
    
    init(title: String, content: String = "", placeHolder: String = "Please input", handleSubject: PassthroughSubject<Void, Never> = .init()) {
        self.title = title
        self.content = content
        self.placeHolder = placeHolder
        self.handleSubject = handleSubject
    }

}

enum RegistrationFormType {
    case avatar(Avatar)
    case firstName(BasicInfo)
    case lastName(BasicInfo)
    case phoneNumber(BasicInfo)
    case email(BasicInfo)
    case avatarColor(BasicInfo)
    case submitBtn
    case none
}

class Identfier: Hashable {
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Identfier, rhs: Identfier) -> Bool {
        lhs.id == rhs.id
    }
}

