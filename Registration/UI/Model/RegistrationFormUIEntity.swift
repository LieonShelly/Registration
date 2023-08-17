//
//  RegistrationFormUIEntity.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine
import UIKit

struct RegistrationFormUIEntity {
    var avatar: UIImage
    var fisrtName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var avatarColor: (red: Float, green: Float, blue: Float)
}

class BasicInfo<T>: Identifiable {
    var title: String
    var placeHolder: String = "Please input"
    var handleSubject: CurrentValueSubject<T?, Never>
    
    init(
        title: String,
        placeHolder: String = "Please input",
        handleSubject: CurrentValueSubject<T?, Never> = .init(nil)
    ) {
        self.title = title
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

struct ButtonEntity {
    var desc: String
    var btnTitle: String
    let handleSubject: PassthroughSubject<Void, Never>
    let btnEnable: AnyPublisher<Bool, Never>
}

class Avatar: Identifiable {
    var title: String = "Avatar"
    let selectSubject: PassthroughSubject<Void, Never>
    
    init(
        title: String = "Avatar",
        selectSubject: PassthroughSubject<Void, Never>
    ) {
        self.selectSubject = selectSubject
        self.title = title
    }
}
