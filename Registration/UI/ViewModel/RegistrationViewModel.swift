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
    enum UIState {
        case success
        case failure(Error)
        case laoding
    }
    // input
    let didClickAvatar: PassthroughSubject<Void, Never> = .init()
    let didClickColorSelectBtn: PassthroughSubject<Void, Never> = .init()
    let didClickSignUpBtn: PassthroughSubject<Void, Never> = .init()
    let firtNameSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let lastNameSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let phoneNumberSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let emailNumberSubject: CurrentValueSubject<String?, Never> = .init(nil)
    let signupBtnEnable: AnyPublisher<Bool, Never>
    let uistate: AnyPublisher<UIState, Never>
    let didSelectAvatar: CurrentValueSubject<UIImage?, Never> = .init(nil)
    let didSelectColor: CurrentValueSubject<(red: Float, green: Float, blue: Float)?, Never> = .init(nil)
    let sections: [Section]
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
    
    init() {
        signupBtnEnable = allValid.eraseToAnyPublisher()
        uistate = uistateSubject.eraseToAnyPublisher()
        usecause = UserInfoUserCase(repository: StandardRegistrationRepository())
        sections = [
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
        configBinding()
    }
    
    func submit() {
        guard allValid.value else { return }
        uistateSubject.send(.laoding)
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
                self.uistateSubject.send(.success)
                
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
        Publishers.CombineLatest(didInputAlltextInfo, didSelectAvatar)
           .print()
           .map { $0 && $1 }
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
