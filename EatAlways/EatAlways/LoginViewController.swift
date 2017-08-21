//
//  LoginViewController.swift
//  EatAlways
//
//  Created by ＳARA on 2017/8/17.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var lblLogin: UIButton!
    @IBOutlet weak var lblLogout: UIButton!
    
    var fbLoginSuccess = false
    var userType:String = USERTYPE_CUSTOMER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil) {
            lblLogin.isHidden = false
            FBManager.getFBUserData(completionHandler: {
                
                self.lblLogin.setTitle("Continue as \(User.currentUser.email!)", for: .normal)
                self.lblLogin.sizeToFit()
            })
        } else {
            self.lblLogout.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true) {
            performSegue(withIdentifier: "CustomerView", sender: self)
        }
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        if (FBSDKAccessToken.current() != nil) {
            APIManager.shared.login(userType: userType, completionHandler: { (error) in
                    self.fbLoginSuccess = true
                    self.viewDidAppear(true)
            })
        } else {
            FBManager.shared.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (
                result, error) in
                if (error == nil) {
                    FBManager.getFBUserData(completionHandler: {
                        APIManager.shared.login(userType: self.userType, completionHandler: { (error) in
                            
                            if (error == nil) {
                                self.fbLoginSuccess = true
                                self.viewDidAppear(true)
                            }
                        })
                    })
                }
            })
        }
    }
    
    @IBAction func lblFBLogout(_ sender: UIButton) {
        APIManager.shared.logout { (error) in
            
            if (error == nil) {
                FBManager.shared.logOut()
                User.currentUser.resetInfo()
                
                self.lblLogout.isHidden = true
                self.lblLogout.setTitle("Login with Facebook", for: .normal)
            }
        }
    }
}
