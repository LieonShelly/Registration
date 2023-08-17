//
//  UserInfoUserCase.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine

class UserInfoUserCase {
    let repository: UserInfoRepository
    
    internal init(repository: UserInfoRepository) {
        self.repository = repository
    }
    
    func submitUserInfo(_ form: RegistrationFormUIEntity) -> AnyPublisher<Bool, Error> {
        let userinfo = RegistrationMapper.mapToServer(form)
        return repository.submitUserInfo(userinfo)
    }
}
