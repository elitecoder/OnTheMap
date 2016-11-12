//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/10/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {

	var region: MKCoordinateRegion? = nil
	var annotation: MKPointAnnotation? = nil
	
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var findOnMapButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		changeButtonVisibility(state: true)
    }
	
	func changeButtonVisibility(state:Bool) {
	
		DispatchQueue.main.async {
			self.findOnMapButton.isHidden = !state
			self.activityIndicator.isHidden = state
		}
	}
	
	// Dismiss keyboard when user touches outside the textfield
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	@IBAction func cancel(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func findOnMap(_ sender: AnyObject) {
		
		guard let location = locationTextField.text else {
			Utility.displayErrorAlert(inViewController: self, withMessage: "Please enter a valid location.")
			return
		}
		
		changeButtonVisibility(state: false)
		
		let request = MKLocalSearchRequest()
		request.naturalLanguageQuery = location
		
		if let region = region {
			request.region = region
		}

		let search = MKLocalSearch(request: request)
		
		search.start { (response, error) in
			
			guard let response = response else {
				print(error)
				Utility.displayErrorAlert(inViewController: self, withMessage: "Location search failed.")
				self.changeButtonVisibility(state: true)
				return
			}
			
			if response.mapItems.count == 0 {
				Utility.displayErrorAlert(inViewController: self, withMessage: "No such location found, please try again.")
				self.changeButtonVisibility(state: true)
			}
			else {
				let item = response.mapItems[0]
				
				self.annotation = MKPointAnnotation()
				self.annotation!.coordinate = item.placemark.coordinate;
				self.annotation!.title = item.name;
				
				DispatchQueue.main.async {
					CurrentUser.sharedInstance().locationString = location // Save the selected Location
					self.performSegue(withIdentifier: "ShareLinkViewSegue", sender: self)
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "ShareLinkViewSegue" {
			let controller = segue.destination as! ShareLinkViewController
			controller.annotation = self.annotation
		}
	}
}
