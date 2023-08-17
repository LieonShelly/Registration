//
//  RegistrationRepository.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine

protocol UserInfoRepository {
    func submitUserInfo(_ info: UserInfo) -> AnyPublisher<Bool, Error>
}
