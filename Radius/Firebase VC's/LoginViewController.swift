//
//  LoginViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var errLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide the error label
        errLbl.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(email)
        Utilities.styleTextField(password)
        Utilities.styleFilledButton(loginBtn)
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        print("LOGIN TAPPED")
        
        // Create clean versions of the text field
        let mail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: mail, password: pass) {
            (result, err) in
            if err != nil {
                print(err!.localizedDescription)
                //self.errorLabel.text = err!.localizedDescription
                //self.errorLabel.alpha = 1
            }else{
                // save mail info in user defaults
                UserDefaults.standard.set(mail, forKey: "email")
                RadarControl.radarSingleton.track()
                self.transition()
            }
        }
    }
    
    func transition(){
        let home = storyboard?.instantiateViewController(identifier: "homeTab") as? HomeTabViewController
        view.window?.rootViewController = home
        view.window?.makeKeyAndVisible()
    }
}

