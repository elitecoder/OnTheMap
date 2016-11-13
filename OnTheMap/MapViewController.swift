//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/9/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var mapView: MKMapView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let locations = LocationDataSource.sharedInstance().studentLocations {
			self.addAnnotationsToMapView(locations: locations)
		}
		else {
			// Location Data not available.
			Utility.refreshLocationDataSource() { (success, error) in
				DispatchQueue.main.async {
					if success {
					self.addAnnotationsToMapView(locations: LocationDataSource.sharedInstance().studentLocations!)
					}
					else {
						Utility.displayErrorAlert(inViewController: self, withMessage: error!)
					}
				}
			}
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		performMapRefresh()
	}
	
	fileprivate func addAnnotationsToMapView(locations: [StudentLocation]) {
		
		var annotations = [MKAnnotation]()
		for location in locations {
			annotations.append(location.getMapKitAnnotation())
		}
		
		mapView.addAnnotations(annotations)
	}
	
	@IBAction func logout(_ sender: AnyObject) {
		
		UdacityClient.sharedInstance().logout { (success, error) in
			
			if CurrentUser.sharedInstance().isFacebookLogin {
				FBSDKLoginManager().logOut()
			}

			DispatchQueue.main.async {
				if success {
					self.dismiss(animated: true, completion: nil)
				}
				else {
					Utility.displayErrorAlert(inViewController: self, withMessage: error!)
				}
			}
		}
	}
	
	@IBAction func postLocation(_ sender: AnyObject) {
		
		Utility.launchingView = .MapView
		
		// If the user has already posted before, simply ask them for overwrite permission
		if let _ = ParseClient.sharedInstance().overwriteObjectId {
			Utility.displayAlertForOverwrite(viewController: self, triggerSegueIdentifier: "MapViewToPostLocationViewSegue")
		}
		else {
			// Else, try and get old locations from Parse
			ParseClient.sharedInstance().getCurrentUserLocations() { (success, locations, error) in
				if success && locations!.count > 0 {
					ParseClient.sharedInstance().overwriteObjectId = locations![0].objectId
					Utility.displayAlertForOverwrite(viewController: self, triggerSegueIdentifier: "MapViewToPostLocationViewSegue")
				}
				else {
					DispatchQueue.main.async {
						self.performSegue(withIdentifier: "PostLocationViewSegue", sender: self)
					}
				}
			}
		}
	}
	
	@IBAction func unwindToMapView(segue: UIStoryboardSegue) {}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PostLocationViewSegue" {
			let controller = segue.destination as! PostLocationViewController
			controller.region = mapView.region
		}
	}

	@IBAction func refresh(_ sender: AnyObject) {
		performMapRefresh()
	}

//	@IBAction func unwindToMapView(segue: UIStoryboardSegue) {
//		if segue.identifier == "UnwindToMapViewSegue" {
//			performMapRefresh()
//		}
//	}
	
	fileprivate func performMapRefresh() {
		Utility.refreshLocationDataSource() { (success, error) in
			DispatchQueue.main.async {
				if success {
					self.reloadAnnotations()
				}
				else {
					Utility.displayErrorAlert(inViewController: self, withMessage: error!)
				}
			}
		}
	}

	fileprivate func reloadAnnotations() {
		
		guard let newLocations = LocationDataSource.sharedInstance().studentLocations else {
			print("Location Data not available.")
			return
		}
		
		let oldAnnotations = self.mapView.annotations
		self.mapView.removeAnnotations(oldAnnotations)
		
		self.addAnnotationsToMapView(locations: newLocations)
	}
	
	// MARK: - MKMapViewDelegate
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "pin"
		
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = UIColor.green
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
			
			if let toOpen = view.annotation?.subtitle! {
				UIApplication.shared.open(NSURL(string: toOpen) as! URL, options: [:], completionHandler: nil)
			}
		}
	}
}
