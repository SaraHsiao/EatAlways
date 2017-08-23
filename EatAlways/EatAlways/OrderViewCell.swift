//
//  OrderViewCell.swift
//  EatAlways
//
//  Created by ＳARA on 2017/8/23.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class OrderViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblMealName: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
