//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Hayne Park on 11/10/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var shareYourProfileLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
    }

    @IBAction func findOnTheMapButtonPressed(_ sender: AnyObject) {
        if locationTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Location empty", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            activityView.startAnimating()
        let geocoder = CLGeocoder()

        guard let location = locationTextField.text else { return }
        
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
            self.activityView.stopAnimating()
        })
    
        findOnTheMapButton.isHidden = true
        questionLabel.isHidden = true
        locationTextField.isHidden = true
        buttonLabel.isHidden = true
        shareYourProfileLabel.isHidden = false
        shareYourProfileLabel.backgroundColor = UIColor(red: 0.00000, green: 0.501961, blue: 0.501961, alpha: 1.0)
        mapView.isHidden = false
        submitButton.isHidden = false
        urlTextField.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.00000, green: 0.501961, blue: 0.501961, alpha: 1.0)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        StudentLocation.sharedInstance.mediaURL = self.urlTextField.text
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            performUIUpdatesOnMain() {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                    
                    Client.sharedInstance().postStudentLocation() { (success, error) in
                        print("Successfully submitted location")
                        performUIUpdatesOnMain() {
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    print("Reachable via Cellular")
                    
                    Client.sharedInstance().postStudentLocation() { (success, error) in
                        print("Successfully submitted location")
                        performUIUpdatesOnMain() {
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            performUIUpdatesOnMain(){
                print("Not reachable")
                let alertController = UIAlertController(title: "Post Fail", message: "Network connection", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {

        var annotations = [MKPointAnnotation]()
        
        // Update View
        findOnTheMapButton.isHidden = false
        //activityIndicatorView.stopAnimating()
        if let error = error {
            let alertController = UIAlertController(title: "Geocoding Fail", message: "Unable to forward geocoode address, try again", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                StudentLocation.sharedInstance.latitude = coordinate.latitude
                StudentLocation.sharedInstance.longitude = coordinate.longitude
                
                let initialLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                let regionRadius: CLLocationDistance = 500
                func centerMapOnLocation(location: CLLocation) {
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                              regionRadius * 2.0, regionRadius * 2.0)
                    mapView.setRegion(coordinateRegion, animated: true)
                }
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                annotations.append(annotation)
                centerMapOnLocation(location: initialLocation)

            } else {
                //locationLabel.text = "No Matching Location Found"
            }
            self.mapView.delegate = self
            self.mapView.addAnnotations(annotations)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor(red: 0.00000, green: 0.501961, blue: 0.501961, alpha: 1.0)
        locationTextField.delegate = self
        urlTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.isHidden = true
        submitButton.isHidden = true
        urlTextField.isHidden = true
        shareYourProfileLabel.isHidden = true
    }
}
