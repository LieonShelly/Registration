//
//  RegistrationMapper.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine

class RegistrationMapper {
    static func mapToServer(_ uiEntity: RegistrationFormUIEntity) -> UserInfo {
        return UserInfo(
            avatarBase64: "",
            fisrtName: uiEntity.fisrtName,
            lastName: uiEntity.lastName,
            phoneNumber: uiEntity.phoneNumber,
            email: uiEntity.email,
            avatarRed: uiEntity.avatarColor.red,
            avatarGreen: uiEntity.avatarColor.green,
            avatarBlue: uiEntity.avatarColor.blue)
    }
}
