//
//  BikeAnalysisViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/31.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BikeAnalysisViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var date: NSDate?
    var distance: Double?
    var duration: Double?
    var routes: [CLLocationCoordinate2D] = []
    var isFromTable = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.layer.cornerRadius = 4
        setNavigation()
        setupBackground()
        setLabel()
        addPolyLineToMap()
    }
    
    func setNavigation(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
        
    }
    
    func setLabel(){
        let distanceStr = NSString(format: "%.2f", distance!)
        distanceLabel.text = String(distanceStr) + " m"
        let speedStr = NSString(format: "%.2f", distance! / duration! * 3.6)
        avgSpeedLabel.text = String(speedStr) + " km / h"
        
        let hours = UInt8(duration! / 3600.0)
        duration! -= (NSTimeInterval(hours) * 3600)
        let minutes = UInt8(duration! / 60.0)
        duration! -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(duration!)
        duration! -= NSTimeInterval(seconds)
        let fraction = UInt8(duration! * 100)
        
        durationLabel.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, fraction)
    
        let calStr = Int(48 * distance! * 0.01 * 1.036)
        caloriesLabel.text = String(calStr) + " kcal"
        
    }
    
    func setupBackground() {
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let topGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60).CGColor
        let bottomGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).CGColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [topGradient, bottomGradient]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = routes.first!
        
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for route in routes {
            minLat = min(minLat, route.latitude)
            minLng = min(minLng, route.longitude)
            maxLat = max(maxLat, route.latitude)
            maxLng = max(maxLng, route.longitude)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    func addPolyLineToMap(){
        var coords = [CLLocationCoordinate2D]()
        for route in routes{
            coords.append(CLLocationCoordinate2D(latitude: route.latitude, longitude: route.longitude))
        }
        
        let polyline = MKPolyline(coordinates: &coords, count: coords.count)
        //        self.mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
        self.mapView.addOverlay(polyline)
        self.mapView.region = mapRegion()
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 10.0
        renderer.strokeColor = UIColor.mrBubblegumColor()
        
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeAnalysis(sender: AnyObject) {
        if isFromTable{
            self.navigationController!.popToRootViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
