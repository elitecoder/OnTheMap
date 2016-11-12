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
		
		if let locations = LocationDataSource.sharedInstance().studentLocation {
			self.addAnnotationsToMapView(locations: locations)
		}
		else {
			print("Location Data not available.")
			
			LocationDataSource.sharedInstance().refresh() { (success, error) in
				DispatchQueue.main.async {
					self.addAnnotationsToMapView(locations: LocationDataSource.sharedInstance().studentLocation!)
				}
			}
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		reloadAnnotations()
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
		
		// If the user has already posted before, simply ask them for overwrite permission
		if let _ = ParseClient.sharedInstance().overwriteObjectId {
			displayAlertForOverwrite()
		}
		else {
			// Else, try and get old locations from Parse
			ParseClient.sharedInstance().getCurrentUserLocations() { (success, locations, error) in
				if success && locations!.count > 0 {
					ParseClient.sharedInstance().overwriteObjectId = locations![0].objectId
					self.displayAlertForOverwrite()
				}
				else {
					DispatchQueue.main.async {
						self.performSegue(withIdentifier: "PostLocationViewSegue", sender: self)
					}
				}
			}
		}
	}
	
	func displayAlertForOverwrite() {
		var alertController:UIAlertController?
		alertController = UIAlertController(title: "",
		                                    message: "You have already posted a Student Location. Would you like to overwrite your Current Location?",
		                                    preferredStyle: .alert)
		
		let overwrite = UIAlertAction(title: "Overwrite",
		                                  style: UIAlertActionStyle.default,
		                                  handler: { (action) in
											DispatchQueue.main.async {
												self.performSegue(withIdentifier: "PostLocationViewSegue", sender: self)
											}
		})
		
		let cancel = UIAlertAction(title: "Cancel",
		                              style: UIAlertActionStyle.cancel,
		                              handler: nil
		)

		alertController!.addAction(cancel)
		alertController!.addAction(overwrite)
		
		self.present(alertController!, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PostLocationViewSegue" {
			let controller = segue.destination as! PostLocationViewController
			controller.region = mapView.region
		}
	}

	@IBAction func refresh(_ sender: AnyObject) {
		performMapRefresh()
	}
	
	func performMapRefresh() {
		LocationDataSource.sharedInstance().refresh { (success, error) in
			if success {
				DispatchQueue.main.async {
					self.reloadAnnotations()
				}
			}
		}
	}
	
	@IBAction func unwindToMapView(segue: UIStoryboardSegue) {
		if segue.identifier == "UnwindToMapViewSegue" {
			performMapRefresh()
		}
	}

	fileprivate func reloadAnnotations() {
		
		guard let newLocations = LocationDataSource.sharedInstance().studentLocation else {
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
