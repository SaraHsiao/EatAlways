//
//  RestaurantViewCell.swift
//  EatAlways
//
//  Created by ＳARA on 2017/8/22.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class RestaurantViewCell: UITableViewCell {
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    @IBOutlet weak var imgResaurantLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
