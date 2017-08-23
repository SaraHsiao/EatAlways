//
//  DriverOrderCell.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/24.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class DriverOrderCell: UITableViewCell {
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerAddress: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
