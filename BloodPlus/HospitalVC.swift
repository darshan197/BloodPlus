//
//  HospitalVC.swift
//  BloodPlus
//
//  Created by Darshan Hosakote on 11/27/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

//import Foundation
import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

class HospitalVC : UIViewController , CLLocationManagerDelegate{
    var googleMapView : GMSMapView!
    var locationManager : CLLocationManager!
    var placePicker : GMSPlacePicker!
    var latitude : Double!
    var longitude : Double!
    
    
   //let locationManager = CLLocationManager()//prompts the user for permission and ask the device for
                                               //the current location
  //  @IBOutlet weak var mapView: MKMapView!
    
  // @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet var mapViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //Do any additional setup after loading the view, typically from a nib.
        //locationManager = CLLocationManager()
//        locationManager.delegate = self
//       locationManager.desiredAccuracy = kCLLocationAccuracyBest  //for best accuracy , can use
//                                                                    //kCLLocationAccuracyHundredMeters 
//                                                                   //for saving batery life
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//        
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.googleMapView layoutIfNeeded()
        self.googleMapView = GMSMapView(frame: self.mapViewContainer.frame)
        self.googleMapView.animateToZoom(18.0)
        self.view.addSubview(googleMapView)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations.last!   //returns an array with at least one CLLocation object
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        
        
        //marker object is constructed with the co ordinates got above
        let coOrdinates = CLLocationCoordinate2DMake(self.latitude,self.longitude)
        let marker = GMSMarker(position: coOrdinates)
        marker.title = "current position"
        marker.map = self.googleMapView
        self.googleMapView.animateToLocation(coOrdinates)
    }
    

}




//extension HospitalVC : CLLocationManagerDelegate{ // to group related delegate methods
//    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse{
//            locationManager.requestLocation()
//        }
//    }
//    
////    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        if let location = locations.first {
////            let span = MKCoordinateSpanMake(0.05, 0.05)
////            let region = MKCoordinateRegionMake(location.coordinate, span)
////            mapView.setRegion(region, animated: true)
////            print ("location: \(location)")
////        }
////    }
////    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
////        print("error :\(error)")
////    }
//}




