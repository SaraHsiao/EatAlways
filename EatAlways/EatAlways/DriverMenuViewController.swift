//
//  DriverMenuViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/23.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class DriverMenuViewController: UITableViewController {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.19, green: 0.18, blue: 0.31, alpha: 1.0)
        
        lblName.text = User.currentUser.name
        
        imgAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        imgAvatar.layer.cornerRadius = 70 / 2
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.clipsToBounds = true
    }
}
