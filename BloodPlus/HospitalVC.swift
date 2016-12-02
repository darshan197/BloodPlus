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

class HospitalVC : UIViewController  ,MKMapViewDelegate{
    let locationManager = CLLocationManager()
    var hospitalLocations:[MKMapItem] = [MKMapItem()]

    @IBOutlet weak var mapView: MKMapView!
    //action to switch between map types i.e., standard and satellite
    @IBAction func switchMapType(sender: AnyObject) {
        if mapView.mapType == MKMapType.Standard {
            mapView.mapType = MKMapType.Satellite
        }
        else {
            mapView.mapType = MKMapType.Standard
        }
    }
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // for best accuracy
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //zoomIn()
        performSearch()
        
    }
    
    func performSearch() {
        
        hospitalLocations.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "hospitals"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response, error) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    
                    self.hospitalLocations.append(item as MKMapItem)
                    print("Matching items = \(self.hospitalLocations.count)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.greenColor()
            //next line sets a button for the right side of the callout...
            let smallSquare = CGSize(width: 30 ,height:30)
            let button = UIButton(frame: CGRect(origin:CGPointZero,size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
            pinView!.rightCalloutAccessoryView = button
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let selectedLoc = view.annotation
        print("Annotation '\(selectedLoc!.title!)' has been selected")
        let currentLocMapItem = MKMapItem.mapItemForCurrentLocation()
        let selectedPlacemark = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
        let mapItems = [selectedMapItem, currentLocMapItem]
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)
    }
}


extension HospitalVC : CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("error:\(error)")
    }
}






