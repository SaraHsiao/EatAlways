//
//  DeliveryViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/24.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import MapKit

class DeliveryViewController: UIViewController {
    
    var orderId: Int?
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    @IBOutlet weak var lblCustomerAddress: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnComplete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        
        APIManager.shared.getCurrentDriverOrder { (json) in
            print(json)
            
            let order = json["order"]
            if let id = order["id"].int, order["status"] == "On the way" {
                self.orderId = id
                
                let from = order["address"].string
                let to = order["restaurant"]["address"].string
                
                let customerName = order["customer"]["name"].string
                let customerAvatar = order["customer"]["avatar"].string
                let customerAddress = order["address"].string
                
                self.lblCustomerName.text = customerName
                self.lblCustomerAddress.text = from
                self.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: customerAvatar!)!))
                self.imgCustomerAvatar.layer.cornerRadius = 50 / 2
                self.imgCustomerAvatar.clipsToBounds = true
                
            } else {
                
                self.map.isHidden = true
                self.viewInfo.isHidden = true
                self.btnComplete.isHidden = true
                
                // Showing a message here
                let lblMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
                lblMessage.center = self.view.center
                lblMessage.textAlignment = .center
                lblMessage.textColor = UIColor.blue
                lblMessage.font = UIFont.init(name: "Marker Felt", size:20)
                lblMessage.text = "Your don't have any orders for delivery."
                
                self.view.addSubview(lblMessage)
            }
        }
    }
}
