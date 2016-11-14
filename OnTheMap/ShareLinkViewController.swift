//
//  ShareLinkViewController.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/10/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import MapKit

class ShareLinkViewController: UIViewController {

	// MARK: Properties
	
	@IBOutlet weak var urlTextField: UITextField!
	@IBOutlet weak var mapView: MKMapView!
	
	var annotation: MKPointAnnotation? = nil
	
	// MARK: View Lifecycle Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let annotation = annotation else {
			return
		}

		mapView.showAnnotations([annotation], animated: true)
    }
	
	// Dismiss keyboard when user touches outside the textfield
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	// MARK: IBActions
	
	@IBAction func cancel(_ sender: AnyObject) {
		
		switch (Utility.launchingView) {
			case .MapView:
					self.performSegue(withIdentifier: "UnwindToMapView", sender: self)
			case .TableView:
					self.performSegue(withIdentifier: "UnwindToTableView", sender: self)
		}
	}
	
	@IBAction func submit(_ sender: AnyObject) {
		
		// Sanity check the URL being shared
		guard let url = urlTextField.text else {
			Utility.displayErrorAlert(inViewController: self, withMessage: "Please enter a valid URL.")
			return
		}
			
		if url.characters.count > 0 {
			CurrentUser.sharedInstance().sharedURL = url
		}
		else {
			Utility.displayErrorAlert(inViewController: self, withMessage: "Please enter a valid URL.")
			return
		}
		
		// Get the coordinates to be share from Annotation
		if let annotation = annotation {
			CurrentUser.sharedInstance().latitude = "\(annotation.coordinate.latitude)"
			CurrentUser.sharedInstance().longitude = "\(annotation.coordinate.longitude)"
		}
		else {
			Utility.displayErrorAlert(inViewController: self, withMessage: "Unable to submit request. Please try again.")
			return
		}

		ParseClient.sharedInstance().postStudentLocation { (success, error) in
			DispatchQueue.main.async {
				if success {
					switch (Utility.launchingView) {
						case .MapView:
							self.performSegue(withIdentifier: "UnwindToMapView", sender: self)
						case .TableView:
							self.performSegue(withIdentifier: "UnwindToTableView", sender: self)
					}

				}
				else {
					Utility.displayErrorAlert(inViewController: self, withMessage: error!)
				}
			}
		}
	}
}
