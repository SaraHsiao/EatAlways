//
//  Restaurant.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/21.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant {
    
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?
    
    // type of JSON
    init(json:JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
    }
}
