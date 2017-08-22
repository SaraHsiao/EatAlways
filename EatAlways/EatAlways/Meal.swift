//
//  Meal.swift
//  EatAlways
//
//  Created by ＳARA on 2017/8/22.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import Foundation
import SwiftyJSON

class Meal {
    
    var id: Int?
    var name: String?
    var short_description: String?
    var image: String?
    var price: Float?
    
    init(json:JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.short_description = json["short_description"].string
        self.image = json["image"].string
        self.price = json["price"].float
    }
}
