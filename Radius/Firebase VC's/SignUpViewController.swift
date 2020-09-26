//
//  SignUpViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var errLbl: UILabel!
    
    var pickerSelection = ""
    
    var arr = ["Flu", "Coughing", "Cold", "None"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide the error label
        errLbl.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(name)
        Utilities.styleTextField(email)
        Utilities.styleTextField(password)
        Utilities.styleFilledButton(signup)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = arr[row]
        print(pickerSelection)
    }

    func validateFields() -> String? {
        // Check that all fields are filled in
        if name.text?.trimmingCharacters(in:
        .whitespacesAndNewlines) == "" ||
        email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields";
        }
                
        // Check that the password is secure
        let cleanedPassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
    //            if(!Utilities.isPasswordValid(cleanedPassword)){
    //                return "Please make sure that your password is at least 8 characters, contains a special character, and a number.";
    //            }
        return nil
    }
            
    func showError(_ message:String){
        print(message)
        //        errorLabel.text = message
        //        errorLabel.alpha = 1
    }
        
    func isInfected() -> Bool? {
        if(pickerSelection == "None"){
            return false
        }
        return true
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        print("SIGN UP TAPPED")
                
        // Validate the fields
        let error = validateFields()
        
        if error != nil{
            // There is something wrong with their fields
            showError(error!)
        }else{
            // Create cleaned versions of the data
            let fullName = name.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let mail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            // Create the user
            Auth.auth().createUser(withEmail: mail, password: pass) { (result, err) in
            // Check for errors
                if err != nil {
                // There was an error creating the user
                    self.showError("Error creating the user")
                }else{
                // User successfully created, now store the first and last names
                    let infected = self.isInfected();
                    let db = Firestore.firestore()
            //                    db.collection("users").addDocument(data:
            //                    ["email": mail, "infected": infected!, "name": fullName, "password": pass]){
                    db.collection("users").document(mail).setData(["email": mail, "infected": infected!, "name": fullName, "password": pass]){
                        (error) in
                                    
                        if error != nil{
                        // Show error message
                        self.showError("Error saving user data")
                        }
                    }
                // Transition to the home screen
                    self.transition()
                }
            }
        }
    }
    
    func transition(){
        let home = storyboard?.instantiateViewController(identifier: "homeTab") as? HomeTabViewController
        view.window?.rootViewController = home
        view.window?.makeKeyAndVisible()
    }
}

