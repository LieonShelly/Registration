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
}

