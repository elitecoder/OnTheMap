//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/8/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {
	
	// MARK: Properties
	let coordinate: CLLocationCoordinate2D
	let firstName: String
	let lastName: String
	let mediaURL: URL
	let objectId: String?
	
	// MARK: Initializer
	init?(dictionary: [String: AnyObject]) {
		
		guard let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double else {
			return nil
		}
		let lat = CLLocationDegrees(latitude)
		
		guard let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double else {
			return nil
		}
		let long = CLLocationDegrees(longitude)
		
		// The lat and long are used to create a CLLocationCoordinates2D instance.
		self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
		
		guard let firstname = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String else {
			return nil
		}
		self.firstName = firstname
		
		guard let lastname = dictionary[ParseClient.JSONResponseKeys.LastName] as? String else {
			return nil
		}
		self.lastName = lastname
		
		guard let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String else {
			return nil
		}
		
		guard let url = NSURL(string: mediaURL) as? URL else {
			return nil
		}
		
		self.mediaURL = url
		
		if let objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String {
			self.objectId = objectId
		}
		else {
			self.objectId = nil
		}
	}
	
	// MARK: Methods
	func getMapKitAnnotation() -> MKPointAnnotation {

		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		annotation.title = "\(firstName) \(lastName)"
		annotation.subtitle = "\(mediaURL)"
		
		return annotation
	}
}
