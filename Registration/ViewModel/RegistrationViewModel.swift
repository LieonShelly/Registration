//
//  RegistrationViewModel.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import Foundation
import UIKit
import Combine

enum RegistrationFormUISize {
    static let avatarRowH: CGFloat = 120
    static let submitSectionBottom: CGFloat = 120
    static let submitRowH: CGFloat = 100
}

class RegistrationViewModel {
    // input
    let didClickAvatar: PassthroughSubject<Void, Never> = .init()
    let didClickColorSelectBtn: PassthroughSubject<Void, Never> = .init()
    let didClickSignUpBtn: PassthroughSubject<Void, Never> = .init()
    
    let firtNameSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let lastNameSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let phoneNumberSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let emailNumberSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let signupBtnEnable: AnyPublisher<Bool, Never>
    
    // output
    let didSelectAvatar: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let didSelectColor: CurrentValueSubject<(red: Float, green: Float, blue: Float)?, Never> = .init(nil)
    
    
    
    var avatarRowH: CGFloat {
        return RegistrationFormUISize.avatarRowH
    }
    
    var submitRowH: CGFloat {
        return RegistrationFormUISize.submitRowH
    }
    
    var basicInfoRowH: CGFloat {
        let navbarH: CGFloat = 103
        let basicItemCount: CGFloat = CGFloat(sections.first(where: { $0.sectionType == .basicInfo})?.items.count ?? 0)
        return (UIScreen.main.bounds.height - navbarH - RegistrationFormUISize.avatarRowH -
                (RegistrationFormUISize.submitRowH + RegistrationFormUISize.submitSectionBottom)) / basicItemCount
    }
    var sections: [Section]
    
    init() {
        let didInputAlltextInfo = Publishers.CombineLatest4(
            firtNameSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher(),
            lastNameSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher(),
            phoneNumberSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher(),
            emailNumberSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher()
        ).map { $0 && $1 && $2 && $3 }
            .eraseToAnyPublisher()
        
        let didSelectAvatar = didSelectAvatar.map { $0 != nil }.eraseToAnyPublisher()
        signupBtnEnable = Publishers.CombineLatest(didInputAlltextInfo, didSelectAvatar)
            .print()
            .map { $0 && $1 }
            .eraseToAnyPublisher()
        
        self.sections = [
            Section(sectionType: .avatar, items: [
                .init(cellType: .avatar(.init(
                    filePath: "",
                    selectSubject: didClickAvatar
                )))]),
            Section(sectionType: .basicInfo, items: [
                .init(cellType: .firstName(.init(title: "Firt Name", handleSubject: firtNameSubject))),
                .init(cellType: .lastName(.init(title: "Last Name", handleSubject: lastNameSubject))),
                .init(cellType: .phoneNumber(.init(title: "phone Number", handleSubject: phoneNumberSubject))),
                .init(cellType: .email(.init(title: "Email", handleSubject: emailNumberSubject))),
                .init(cellType: .avatarColor(.init(
                    desc: "Customer Avatar Color",
                    btnTitle: "Please Select",
                    handleSubject: didClickColorSelectBtn,
                    btnEnable: CurrentValueSubject<Bool, Never>(true).eraseToAnyPublisher()
                )))
            ]),
            Section(sectionType: .submitBtn, items: [.init(cellType: .submitBtn(.init(
                desc: "",
                btnTitle: "Sign Up",
                handleSubject: didClickSignUpBtn,
                btnEnable: signupBtnEnable
            )))])
        ]
       
    }
    
    func submit() {
        let firstNameValue = firtNameSubject.value
        let lastNameValue = lastNameSubject.value
        let phoneNumberValue = phoneNumberSubject.value
        let email = emailNumberSubject.value
        let avatarColor = didSelectColor.value
    }
}
