//
//  hospitalSearchTable.swift
//  BloodPlus
//
//  Created by Darshan Hosakote  on 11/29/16.
//  Copyright © 2016 DarshanHosakote. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems : [MKMapItem] = []
    var mapView: MKMapView? = nil
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        
    }
    
    
func parseAddress(selectedItem: MKPlacemark) -> String {
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.subAdministrativeArea != nil) ? ", " : ""
    
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
        format : "%@%@%@%@%@%@%@",
        selectedItem.subThoroughfare ?? "",
        firstSpace,
        selectedItem.thoroughfare ?? "",
        comma,
        selectedItem.locality ?? "",
        secondSpace,
        selectedItem.administrativeArea ?? "")
    return addressLine
    }
}


extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController){
        guard let mapView = mapView,
           
    let searchBarText = searchController.searchBar.text else { return }
    let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler {response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        
}
}
}



extension LocationSearchTable{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(tableView: UITableView , cellForRowAtIndexPath indexPath : NSIndexPath )-> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
    
    }
    
}

extension LocationSearchTable{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
    }
}



