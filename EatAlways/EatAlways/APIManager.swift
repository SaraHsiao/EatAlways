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
import CoreLocation

class APIManager {
    
    static let shared = APIManager()
    
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    /********** CUSTOMERS **********/
    
    // API - to Login an User
    func login(userType: String, completionHandler: @escaping (NSError?) -> Void ) {
        
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        
        let params:[String:Any] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": FBSDKAccessToken.current().tokenString,
            "user_type": userType
        ]
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let jsonData = JSON(value)
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    // API - to Log and User Out
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        
        let path = "api/social/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        
        let params:[String:Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": self.accessToken   //this token is return server, not facebook
        ]
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseString { (response) in
            
            switch response.result {
            case .success:
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    // API - To Refresh the Token When it's Expired
    func refreshTokenIfNeed (completionHandler: @escaping () -> Void) {
        
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        
        let params:[String:Any] = [
            "access_token":self.accessToken,
            "refresh_token": self.refreshToken,
            ]
        if (Date() > self.expired) {
            
            Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    self .accessToken = jsonData["access_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    completionHandler()
                    break
                case .failure:
                    break
                }
            })
        } else {
            completionHandler()
        }
    }
    
    // Request Server Function
    func requestServer(_ method: HTTPMethod, _ path: String, _ params: [String:Any]?, _ encoding: ParameterEncoding, _ completionHandler: @escaping(JSON) -> Void) {
        
        let url = baseURL?.appendingPathComponent(path)
        
        refreshTokenIfNeed {
            
            Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            }
        }
    }
    
    // API - Getting Restaurants List
    func getRestaurants (completionHandler: @escaping (JSON) -> Void) {
        
        let path = "api/customer/restaurants/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    // API - Getting List of Meals of a Restaurant
    func getMeals(restaurantId: Int, completionHandler: @escaping (JSON) -> Void) {
        
        let path = "api/customer/meals/\(restaurantId)"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    // API - Creating New Order
    func createOrder(stripeToken: String, completionHandler: @escaping (JSON) -> Void) {
        
        let path = "api/customer/order/add/"
        let simpleArray = Tray.currentTray.items
        let jsonArray = simpleArray.map { item in
            return [
                "meal_id": item.meal.id!,
                "quantity": item.qty
            ]
        }
        
        if JSONSerialization.isValidJSONObject(jsonArray) {
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                
                let params: [String: Any] = [
                    "access_token": self.accessToken,
                    "stripe_token": stripeToken,
                    "restaurant_id": "\(Tray.currentTray.restaurant!.id!)",
                    "order_details": dataString,
                    "address": Tray.currentTray.address!
                ]
                requestServer(.post, path, params, URLEncoding(), completionHandler)
            }
            catch {
                print("JSON serialization failed: \(error)")
            }
        }
    }
    
    //API - Getting the Latest Order - Customer
    func getLatestOrder (completionHandler: @escaping(JSON) -> Void) {
        
        let path = "api/customer/order/latest/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    /********** DRIVERS **********/
    
    // API - Getting List of Orders that are Read
    func getDriverOrders(completionHandler: @escaping(JSON) -> Void) {
        
        let path = "api/driver/orders/ready/"
        
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    //API - Picking Up a Ready Order
    func pickOrder(orderId:Int, completionHandler: @escaping (JSON) -> Void) {
        
        let path = "api/driver/order/pick/"
        let params: [String:Any] = [
            "order_id":"\(orderId)",
            "access_token":self.accessToken
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Getting the Current Driver's Order
    func getCurrentDriverOrder (completionHandler: @escaping(JSON) -> Void) {
        
        let path = "api/driver/order/latest/"
        let params: [String:Any] = [
        "access_token": self.accessToken
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
}
