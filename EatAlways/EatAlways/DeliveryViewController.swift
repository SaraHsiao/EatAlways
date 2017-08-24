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
    }

}
