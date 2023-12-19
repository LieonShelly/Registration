//
//  ViewController.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func registerBtnAction(_ sender: UIButton) {
        let registerVC = RegistrationViewController(viewModel: .init(repository: StandardRegistrationRepository()))
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @Wrapper
    var intValue: Int = 1
}

@propertyWrapper
struct Wrapper<T> {
    var wrappedValue: T {
        didSet {
        }
    }
    var projectedValue: String
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.projectedValue = "projectedValue:\(wrappedValue)"
    }
}

