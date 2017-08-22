//
//  TrayViewCell.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/23.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class TrayViewCell: UITableViewCell {

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
        lblQty.layer.borderColor = UIColor.gray.cgColor
        lblQty.layer.borderWidth = 1.0
        lblQty.layer.cornerRadius = 10
    }
    

}
