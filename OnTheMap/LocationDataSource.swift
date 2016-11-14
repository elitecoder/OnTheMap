//
//  LocationDataSource.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/9/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

// MARK: - LocationDataSource

class LocationDataSource {
	
	// MARK: Properties
	
	var studentLocations: [StudentLocation]?
	
	// MARK: Shared Instance
	
	class func sharedInstance() -> LocationDataSource {
		struct Singleton {
			static var sharedInstance = LocationDataSource()
		}
		
		return Singleton.sharedInstance
	}
}
