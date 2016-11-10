//
//  ViewController.swift
//  On The Map
//
//  Created by Hayne Park on 11/3/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func pressedLoginButton(_ sender: AnyObject) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.setUIEnabled(enabled: true)
            let alertController = UIAlertController(title: "Login Fail", message: "Username or Password Empty", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            /*
             Steps for Authentication...
             https://www.themoviedb.org/documentation/api/sessions
             
             Step 1: Create a request token
             Step 2: Ask the user for permission via the API ("login")
             Step 3: Create a session ID
             
             Extra Steps...
             Step 4: Get the user id ;)
             Step 5: Go to the next view!
             */
            getRequestToken()

        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }

    
    func getRequestToken() {
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.baseURLSecureString)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(enabled: true)
                    self.debugTextLabel.text = "Login Failed (User ID)."
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError(error: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode! == 403 {
                performUIUpdatesOnMain {
                    self.setUIEnabled(enabled: true)
                    let alertController = UIAlertController(title: "Login Fail", message: "Incorrect Credentials", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            } else if statusCode! >= 400 && statusCode! != 403 {
                performUIUpdatesOnMain {
                    self.setUIEnabled(enabled: true)
                    let alertController = UIAlertController(title: "Login Fail", message: "Failure to Connect", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(error: "No data was returned by the request!")
                return
            }

            let dataLength = data.count
            let r = 5...Int(dataLength)
            let newData = data.subdata(in: Range(r)) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue))
            
            /* 5. Parse the data */
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
            } catch {
                displayError(error: "Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            /* GUARD: Is the "id" key in parsedResult? */
            if let jsonResult = parsedResult["session"] as? [String: AnyObject] {
                let sessionID = jsonResult["id"] as! String
                print("session: \(sessionID)")
            }
            self.setUIEnabled(enabled: true)
            self.completeLogin()
        }
        task.resume()  
    }
}

// MARK: - ViewController (Configure UI)

extension ViewController {
    
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

