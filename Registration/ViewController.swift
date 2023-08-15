//
//  ViewController.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func registerBtnAction(_ sender: UIButton) {
        let registerVC = RegistrationViewController(viewModel: .init())
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

