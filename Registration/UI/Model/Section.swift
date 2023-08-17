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
    
    init(
        filePath: String,
        selectSubject: PassthroughSubject<Void, Never>
    ) {
        self.filePath = filePath
        self.selectSubject = selectSubject
    }
}

class BasicInfo<T>: Identfier {
    var title: String
    var content: String = ""
    var placeHolder: String = "Please input"
    var handleSubject: CurrentValueSubject<T?, Never>
    
    init(title: String, content: String = "", placeHolder: String = "Please input", handleSubject: CurrentValueSubject<T?, Never> = .init(nil)) {
        self.title = title
        self.content = content
        self.placeHolder = placeHolder
        self.handleSubject = handleSubject
    }
}

enum RegistrationFormType {
    case avatar(Avatar)
    case firstName(BasicInfo<String>)
    case lastName(BasicInfo<String>)
    case phoneNumber(BasicInfo<String>)
    case email(BasicInfo<String>)
    case avatarColor(ButtonEntity)
    case submitBtn(ButtonEntity)
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


struct ButtonEntity {
    var desc: String
    var btnTitle: String
    let handleSubject: PassthroughSubject<Void, Never>
    let btnEnable: AnyPublisher<Bool, Never>
}
