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
    var destination:MKPlacemark?
    var source:MKPlacemark?
    
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
                
                let from = order["address"].string!
                let to = order["restaurant"]["address"].string!
                
                let customerName = order["customer"]["name"].string
                let customerAvatar = order["customer"]["avatar"].string
                let customerAddress = order["address"].string
                
                self.lblCustomerName.text = customerName
                self.lblCustomerAddress.text = from
                self.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: customerAvatar!)!))
                self.imgCustomerAvatar.layer.cornerRadius = 50 / 2
                self.imgCustomerAvatar.clipsToBounds = true
                
                self.getLocation(from, "Customer", completionHandler: { (sou) in
                    self.source = sou
                    
                    self.getLocation(to, "Restaurant", completionHandler: { (des) in
                        self.destination = des
                        self.getDirections()
                    })
                })
                
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

extension DeliveryViewController:MKMapViewDelegate {
    
    // 1. Delegate method of MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
    // 2. Convert an address string to the location on the map
    func getLocation(_ address: String, _ title: String, completionHandler: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if (error != nil) {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Create a Pin on Map
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                
                self.map.addAnnotation(dropPin)
                completionHandler(MKPlacemark(placemark: placemark))
            }
        }
    }
    
    // 3. Get Direction and zoom to address
    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.init(placemark: source!)
        request.destination = MKMapItem.init(placemark: destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if (error != nil) {
                print("Error:", error)
                
            } else {
                
                // Show route
                self.showRoute(response: response!)
            }
        }
    }
    
    // 4. Show route between location and make a visible zoom
    func showRoute(response: MKDirectionsResponse) {
        
        for ruote in response.routes {
            self.map.add(ruote.polyline, level:MKOverlayLevel.aboveRoads)
        }
        var zoomRect = MKMapRectNull
        for annotation in self.map.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let optionRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, optionRect)
        }
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
        self.map.setVisibleMapRect(insetRect, animated: true)
    }
}
