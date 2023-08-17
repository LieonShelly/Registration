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
