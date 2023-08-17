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
    static let submitSectionBottom: CGFloat = 80
    static let submitRowH: CGFloat = 100
}

class RegistrationViewModel {
    enum UIState {
        case success
        case failure(Error)
        case laoding
    }
    let didClickAvatar: PassthroughSubject<Void, Never> = .init()
    let didClickColorSelectBtn: PassthroughSubject<Void, Never> = .init()
    let didClickSignUpBtn: PassthroughSubject<Void, Never> = .init()
    let firtNameSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let lastNameSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let phoneNumberSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let emailNumberSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let didSelectAvatar: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let didSelectColor: CurrentValueSubject<(red: Float, green: Float, blue: Float)?, Never> = .init(nil)
    let sections: [Section]
    let signupBtnEnable: AnyPublisher<Bool, Never>
    let uistate: AnyPublisher<UIState, Never>
    private let usecause: UserInfoUserCase
    private var bag: Set<AnyCancellable> = .init()
    private let uistateSubject: PassthroughSubject<UIState, Never> = .init()
    private let allValid: CurrentValueSubject<Bool, Never> = .init(false)
    
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
    
    init(repository: UserInfoRepository) {
        signupBtnEnable = allValid.eraseToAnyPublisher()
        uistate = uistateSubject.eraseToAnyPublisher()
        usecause = UserInfoUserCase(repository: repository)
        sections = [
            Section(sectionType: .avatar, items: [
                .init(cellType: .avatar(.init(
                    selectSubject: didClickAvatar
                )))]),
            Section(sectionType: .basicInfo, items: [
                .init(cellType: .firstName(.init(title: "Firt Name", handleSubject: firtNameSubject))),
                .init(cellType: .lastName(.init(title: "Last Name", handleSubject: lastNameSubject))),
                .init(cellType: .phoneNumber(.init(title: "Phone Number", handleSubject: phoneNumberSubject))),
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
        configBinding()
    }
    
    func submit() {
        uistateSubject.send(.laoding)
        guard allValid.value else {
            return uistateSubject.send(.failure(NSError(domain: "Field dismiss", code: -101)))
        }
        let form = RegistrationFormUIEntity(
            avatar: didSelectAvatar.value!,
            fisrtName: firtNameSubject.value!,
            lastName: lastNameSubject.value!,
            phoneNumber: phoneNumberSubject.value!,
            email: emailNumberSubject.value!,
            avatarColor: didSelectColor.value!
            )
        usecause.submitUserInfo(form)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.uistateSubject.send(.failure(error))
                }
            }, receiveValue: {[weak self] value in
                guard let self = self else { return }
                if value {
                    self.uistateSubject.send(.success)
                } else {
                    self.uistateSubject.send(.failure(NSError(domain: "Submit failed", code: -100)))
                }
            })
            .store(in: &bag)
    }
}

extension RegistrationViewModel {
    private func configBinding() {
        let didInputAlltextInfo = Publishers.CombineLatest4(
            firtNameSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher(),
            lastNameSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher(),
            phoneNumberSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher(),
            emailNumberSubject.filter { $0 != nil }.map { !$0!.isEmpty}.eraseToAnyPublisher()
        ).map { $0 && $1 && $2 && $3 }
            .eraseToAnyPublisher()
        
        let didSelectAvatar = didSelectAvatar.map { $0 != nil }.eraseToAnyPublisher()
        let didSelectColor = self.didSelectColor.map { $0 != nil }.eraseToAnyPublisher()
        Publishers.CombineLatest3(didInputAlltextInfo, didSelectAvatar, didSelectColor)
           .map { $0 && $1 && $2 }
           .sink(receiveValue: { [weak self] valid in
               guard let self = self else { return }
               self.allValid.send(valid)
           })
           .store(in: &bag)
        
        didClickSignUpBtn
            .eraseToAnyPublisher()
            .sink {  [weak self] _ in
                self?.submit()
            }
            .store(in: &bag)
    }
}
