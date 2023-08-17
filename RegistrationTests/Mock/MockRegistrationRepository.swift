//
//  MockRegistrationRepository.swift
//  RegistrationTests
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine
@testable import Registration

class MockRegistrationRepository: UserInfoRepository {
    var response: Bool = false
    
    func submitUserInfo(_ info: UserInfo) -> AnyPublisher<Bool, Error> {
        return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
