//
//  RegistrationViewModelTests.swift
//  RegistrationTests
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import Combine
import XCTest
@testable import Registration

final class RegistrationViewModelTests: XCTestCase {
    var sut: RegistrationViewModel!
    var bag: Set<AnyCancellable> = .init()
    var repository: MockRegistrationRepository = .init()
    
    override func setUpWithError() throws {
        sut = .init(repository: repository)
    }

    fileprivate func testSubmit(_ expectResult: Bool) {
        let excpect = expectation(description: #function)
        
        var result: Bool = false
        sut.uistate
            .sink(receiveValue: {state in
                switch state {
                case .failure:
                    result = false
                    excpect.fulfill()
                case .success:
                    result = true
                    excpect.fulfill()
                case .laoding:
                    result = false
                }
            })
            .store(in: &bag)
        
        // When
        sut.submit()
        
        // Then
        wait(for: [excpect], timeout: 0.01)
        XCTAssertEqual(result, expectResult)
    }
    
    func testShouldSubmitSuccessWhenAllInfoIsValid() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = (233, 22, 22)
        repository.response = true
        testSubmit(true)
    }
    
    func testShouldSubmitFailWhenFirstNameIsEmpty() {
        // Given
        sut.firtNameSubject.value = ""
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = (233, 22, 22)
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenFirstNameIsNil() {
        // Given
        sut.firtNameSubject.value = nil
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = (233, 22, 22)
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenAvatarIsNil() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = nil
        sut.didSelectColor.value = (233, 22, 22)
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenColorIsNil() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }

    func testShouldSubmitFailWhenLastNameIsNil() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = nil
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenLastNameIsEmpty() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = ""
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }
    
    
    func testShouldSubmitFailWhenPhoneNumberIsNil() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = nil
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenPhoneNumberIsEmpty() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = ""
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }
    
    
    func testShouldSubmitFailWhenEmailIsNil() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = nil
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenEmailIsEmpty() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = ""
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = nil
        repository.response = true
        testSubmit(false)
    }
    
    func testShouldSubmitFailWhenServerResponseFail() {
        // Given
        sut.firtNameSubject.value = "first name"
        sut.lastNameSubject.value = "last name"
        sut.phoneNumberSubject.value = "15692131123"
        sut.emailNumberSubject.value = "first@em.com"
        sut.didSelectAvatar.value = UIImage(named: "home")
        sut.didSelectColor.value = (233, 22, 22)
        repository.response = false
        testSubmit(false)
    }
}
