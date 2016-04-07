//
//  AddLocationVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse

class AddLocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var updateLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationManager.startUpdatingLocation()
        
        }
        
        //Setup the map
        mapView.delegate = self
        
        mapView.mapType = MKMapType.Standard
        
        mapView.showsUserLocation = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //locationManager.requestLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var userLocation:CLLocation = locations[0]
        
        let long = userLocation.coordinate.longitude
        
        let lat = userLocation.coordinate.latitude
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        
        //Flag to update location.  Add button or refresh to find current location but setting updateLocation to true
        
        if updateLocation == true {
        
            updateLocation = !updateLocation
            
            mapView.setRegion(region, animated: true)
        
            print(userLocation)
        
        }

    }
    
}