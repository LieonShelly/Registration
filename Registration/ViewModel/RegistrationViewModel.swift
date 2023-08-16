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
    let avatarSelectObject: PassthroughSubject<Void, Never> = .init()
    let avatarValue: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let colorValue: CurrentValueSubject<UIColor?, Never> = .init(nil)
    let selectColor: PassthroughSubject<Void, Never> = .init()
    
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
        self.sections = [
            Section(sectionType: .avatar, items: [
                .init(cellType: .avatar(.init(
                    filePath: "",
                    selectSubject: avatarSelectObject,
                    currentImage: avatarValue
                )))]),
            Section(sectionType: .basicInfo, items: [
                .init(cellType: .firstName(.init(title: "Firt Name"))),
                .init(cellType: .lastName(.init(title: "Last Name"))),
                .init(cellType: .phoneNumber(.init(title: "phone Number"))),
                .init(cellType: .email(.init(title: "Email"))),
                .init(cellType: .avatarColor(.init(title: "Customer Avatar Color", handleSubject: selectColor)))
            ]),
            Section(sectionType: .submitBtn, items: [.init(cellType: .submitBtn)])
        ]
    }
}
