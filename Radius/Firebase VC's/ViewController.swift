//
//  ViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        let login = storyboard?.instantiateViewController(identifier: "login") as? LoginViewController
        view.window?.rootViewController = login
        view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let signup = storyboard?.instantiateViewController(identifier: "signup") as? SignUpViewController
        view.window?.rootViewController = signup
        view.window?.makeKeyAndVisible()
    }
    
}

