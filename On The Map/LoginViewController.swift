//
//  LoginViewController.swift
//  On The Map
//
//  Created by Hayne Park on 11/3/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pressedLoginButton(_ sender: AnyObject) {
        self.setUIEnabled(enabled: false)

        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.setUIEnabled(enabled: true)
            let alertController = UIAlertController(title: "Login Fail", message: "Username or Password Empty", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            self.setUIEnabled(enabled: true)
        } else {
            Client.sharedInstance().authenticateWithViewController(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                if error == nil {
                Client.sharedInstance().getUserData() { (success, error) in
                        performUIUpdatesOnMain() {
                            self.setUIEnabled(enabled: true)
                        }
                        self.completeLogin()
                    }
                } else {
                    let alertController = UIAlertController(title: "Login Fail", message: error?.description, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    self.setUIEnabled(enabled: true)
                }
            }
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }

    
    func getRequestToken(completionHandler handler:@escaping (String) -> Void) {
        

    }
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
     func setUIEnabled(enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}

