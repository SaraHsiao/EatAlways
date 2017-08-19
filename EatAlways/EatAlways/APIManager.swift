//
//  APIManager.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/19.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APIManager {
    
    static let shared = APIManager()
    
    let baseURL = NSURL(string: "Localhost:8000/")
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Data()
    
    // API to login an user
    func login(userType: String, completionHandler: @escaping (NSError?) -> Void ) {
        
    }
    
    // API to log and user out
    func logout(completionHandle: @escaping (NSError?) -> Void) {
        
    }
    
}
