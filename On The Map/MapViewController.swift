//
//  MapViewController.swift
//  On The Map
//
//  Created by Hayne Park on 11/8/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        Client.sharedInstance().logoutSession { (success, error) in
            self.dismiss(animated: true, completion: nil)
            print("Successfully logged out")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getStudentLocation{ (results) -> () in
        }
    }
    

    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: { (nil) in
                    print("works")
                })
            }
        }
    }

    func getStudentLocation(completionHandler handler:@escaping ([[String:AnyObject]]) -> Void) {
        Client.sharedInstance().getStudentLocations { (results, errorString) in
            if(results != nil) {
                performUIUpdatesOnMain() {
                    self.setStudentLocation()
                }
            } else {
                let alertController = UIAlertController(title: "Download Fail", message: "Unable to download student locations", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func setStudentLocation() {
        
        var annotations = [MKPointAnnotation]()
        
        for location in StudentLocation.sharedInstance.studentLocationList {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            if location.firstName != nil && location.lastName != nil && location.latitude != nil && location.longitude != nil && location.mediaURL != nil {
                let lat = CLLocationDegrees(location.latitude! as Double)
                let long = CLLocationDegrees(location.longitude! as Double)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = location.firstName! as String
                let last = location.lastName! as String
                let mediaURL = location.mediaURL! as String
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }

        }
                
            // When the array is complete, we add the annotations to the map.
            self.mapView.delegate = self
            self.mapView.addAnnotations(annotations)
    }
}
