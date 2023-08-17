//
//  UserInfo.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation

struct UserInfo: Codable {
    var avatarBase64: String
    var fisrtName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var avatarRed: Float
    var avatarGreen: Float
    var avatarBlue: Float
}
