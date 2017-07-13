/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    var signupMode = true
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signupOrLoginBtn: UIButton!
    @IBOutlet var changeSignupModeBtn: UIButton!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if signupMode {
        
        let user = PFUser()
        
        user.username = usernameField.text
        user.password = passwordField.text
            
        let acl = PFACL()
        
        acl.getPublicWriteAccess = true
            
            user.acl = acl
        
        user.signUpInBackground { (success, error) in
            
            if error != nil {
                
                var errorMessage = "Sign Up failed, please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                print("Signed Up")
                
                self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                
            }
            
        }
            
        } else {
            
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: { (user, error) in

                if error != nil {
                    
                    var errorMessage = "Sign Up failed, please try again"
                    
                    let error = error as NSError?
                    
                    if let parseError = error?.userInfo["error"] as? String {
                        
                        errorMessage = parseError
                        
                    }
                    
                    self.errorLabel.text = errorMessage
                    
                } else {
                    
                    print("Logged In")
                    
                    self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                    
                }
            })
            
        }
        
        
    }
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            
            signupMode = false
            
            signupOrLoginBtn.setTitle("Log In", for: [])
            
            changeSignupModeBtn.setTitle("Sign Up", for: [])
            
        } else {
            
            signupMode = true
            
            signupOrLoginBtn.setTitle("Sign Up", for: [])
            
            changeSignupModeBtn.setTitle("Log In", for: [])
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "goToUserInfo", sender: self)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
