//
//  RegistrationViewModel.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import Foundation
import UIKit


enum Section: Hashable {
    case avatar
    case basicInfo
    case submitBtn
    
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
    
    var id: String {
        switch self {
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
    
    init(filePath: String) {
        self.filePath = filePath
    }
}

class BasicInfo: Identfier {
    var title: String
    var content: String = ""
    var placeHolder: String = "Please input"
    
    init(title: String, content: String = "", placeHolder: String = "Please input") {
        self.title = title
        self.content = content
        self.placeHolder = placeHolder
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

