//
//  MealViewCell.swift
//  EatAlways
//
//  Created by ＳARA on 2017/8/22.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMealName: UILabel!
    @IBOutlet weak var lblMealShortDescriptions: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgMealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
