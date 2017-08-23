//
//  PaymentViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/16.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func placeOrder(_ sender: UIButton) {
        
        APIManager.shared.getLatestOrder { (json) in
            
            if (json["order"]["status"] == nil || json["order"]["status"] == "Delivered") {
                
                // Processing the payment and create an Order
                let card = self.cardTextField.cardParams
                STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
                    if let myError = error {
                        print("Error: ", myError)
                    } else if let stripeToken = token {
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId, completionHandler: { (json) in
                            Tray.currentTray.reset()
                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                        })
                    }
                })
            } else {
                // Showing an alert message
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                let okAction = UIAlertAction(title: "Go to Order", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "ViewOrder", sender: self)
                })
                let alertView = UIAlertController(title: "Already Order?", message: "You current order is not completed", preferredStyle: .alert)
                
                alertView.addAction(cancelAction)
                alertView.addAction(okAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
}
