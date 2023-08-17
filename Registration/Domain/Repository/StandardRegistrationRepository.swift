//
//  StandardRegistrationRepository.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine

class StandardRegistrationRepository: UserInfoRepository {
    func submitUserInfo(_ info: UserInfo) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                promise(.success(true))
            })
        }.eraseToAnyPublisher()
    }
}
