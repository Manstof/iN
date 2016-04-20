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

class AddLocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //Search
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    //Placemarks
    var currentPlacemark:CLPlacemark?
    var selectedLocation:CLLocation!
    let geoCoder = CLGeocoder()
    
    //Location
    let locationManager = CLLocationManager()
    var updateLocation = true
    
    //Saving Location
    var selectedLocationName: String!
    var selectedLocationAddress: String!
    var passedSelectedLocationName: String!
    var passedSelectedLocationAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User
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
        
        //Customize the search bar in a hack of a way to make the background tranparent
        let image = UIImage()
        
        searchBar.setBackgroundImage(image, forBarPosition: .Any, barMetrics: .Default)
        
        searchBar.scopeBarBackgroundImage = image
        
        //TODO: Increase the height if the searchBar http://stackoverflow.com/questions/30858969/can-the-height-of-the-uisearchbar-textfield-be-modified
        //TODO: Make the search bar prettier
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //locationManager.requestLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //User location and mapView
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let long = userLocation.coordinate.longitude
        
        let lat = userLocation.coordinate.latitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        //TODO: Add button or refresh to find current location but setting updateLocation to true
        
        if updateLocation == true {
        
            updateLocation = !updateLocation
            
            mapView.setRegion(region, animated: true)
        
        }
    }
    
    //Search Bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar){

        //Deactivate the search bar
        searchBar.resignFirstResponder()
        
        if self.mapView.annotations.count != 0 {
            
            annotation = self.mapView.annotations[0]
            
            self.mapView.removeAnnotation(annotation)
        
        }
        
        //Start the local search
        //TODO: Select closest annotation to users location
        localSearchRequest = MKLocalSearchRequest()
        
        localSearchRequest.naturalLanguageQuery = searchBar.text
        
        localSearchRequest.region = mapView.region
        
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
        
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
        
            }
            
            let mapItems = localSearchResponse!.mapItems
            
            var nearbyAnnotations:[MKAnnotation] = []
            
            if mapItems.count > 0 {
            
                for item in mapItems {
                
                    // Add annotation to map
                    let annotation = MKPointAnnotation()
                    
                    annotation.title = item.name
                    
                    annotation.subtitle = item.placemark.locality
                    
                    if let location = item.placemark.location {
                    
                        annotation.coordinate = location.coordinate
                    
                    }
                    
                    nearbyAnnotations.append(annotation)
                
                }
            }
            
            self.mapView.showAnnotations(nearbyAnnotations, animated: true)
        
        }
    }
    
    //Working with placemarks
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
        
            return nil
            
        }
        
        //Reuse the annotation if possible
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView

        if annotationView == nil {
        
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
            
            annotationView?.pinTintColor = UIColor.redColor()
            
        }
        
        //annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        
        return annotationView
    
    }
    
    //Process info of the selected pin
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        let pin = view.annotation!
        
        selectedLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(selectedLocation, completionHandler: {(placemarks, error) -> Void in
            
            var placemark:CLPlacemark!
            
            if error == nil && placemarks?.count > 0 {
                
                placemark = (placemarks?[0])! as CLPlacemark
                
                var addressString : String = ""
                
                if placemark.ISOcountryCode == "TW" {
                
                    if placemark.country != nil {
                    
                        addressString = placemark.country!
                    
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                    
                        addressString = addressString + placemark.subAdministrativeArea! + ", "
                    
                    }
                    
                    if placemark.postalCode != nil {
                    
                        addressString = addressString + placemark.postalCode! + " "
                    
                    }
                    
                    if placemark.locality != nil {
                    
                        addressString = addressString + placemark.locality!
                    
                    }
                    
                    if placemark.thoroughfare != nil {
                    
                        addressString = addressString + placemark.thoroughfare!
                    
                    }
                    
                    if placemark.subThoroughfare != nil {
                    
                        addressString = addressString + placemark.subThoroughfare!
                    
                    }
                
                } else {
                
                    if placemark.subThoroughfare != nil {
                    
                        addressString = placemark.subThoroughfare! + " "
                    
                    }
                    
                    if placemark.thoroughfare != nil {
                    
                        addressString = addressString + placemark.thoroughfare! + ", "
                    
                    }
                    
                    if placemark.postalCode != nil {
                    
                        addressString = addressString + placemark.postalCode! + " "
                    
                    }
                    
                    if placemark.locality != nil {
                    
                        addressString = addressString + placemark.locality! + ", "
                
                    }
                
                    if placemark.administrativeArea != nil {
                    
                        addressString = addressString + placemark.administrativeArea! + " "
                    
                    }
                    
                    if placemark.country != nil {
                    
                        addressString = addressString + placemark.country!
                    
                    }
                }
                
                self.selectedLocationName = pin.title!
                
                self.selectedLocationAddress = addressString
                
            }
        })
    }
    
    //Unwind segue back to the createEventVC screen
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        passedSelectedLocationName = selectedLocationName
        
        passedSelectedLocationAddress = selectedLocationAddress
        
        performSegueWithIdentifier("unwindAddLocationToCreateEvent", sender: self)
        
    }
}