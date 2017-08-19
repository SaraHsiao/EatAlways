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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil) {
            lblLogin.isHidden = false
            FBManager.getFBUserData(completionHandler: { 
                
                self.lblLogin.setTitle("Continue as \(User.currentUser.email!)", for: .normal)
                self.lblLogin.sizeToFit()
                
            })
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true) {
            performSegue(withIdentifier: "CustomerView", sender: self)
        }
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        if (FBSDKAccessToken.current() != nil) {
            fbLoginSuccess = true
            self.viewDidAppear(true)
        } else {
            FBManager.shared.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (
                result, error) in
                
                if (error == nil) {
                    
                    FBManager.getFBUserData(completionHandler: { 
                        self.fbLoginSuccess = true
                        self.viewDidAppear(true)
                    })
                }
            })
        }
    }
    
    
    @IBAction func lblFBLogout(_ sender: UIButton) {
        FBManager.shared.logOut()
        User.currentUser.resetInfo()
        
        lblLogout.isHidden = true
        lblLogin.setTitle("Login With Facebook", for: .normal)
        
    }
    
}
