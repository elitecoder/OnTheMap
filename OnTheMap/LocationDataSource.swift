//
//  LocationDataSource.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/9/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//


class LocationDataSource {
	
	// MARK: Properties
	
	var studentLocation: [StudentLocation]?
	var skip: Int
	
	// MARK: Initializer
	
	init() {
		skip = 0
	}
	
	// MARK: Public Methods
	
	func refresh(completionHandler: @escaping (_ success: Bool, _ error: String?)->Void) {
		
		ParseClient.sharedInstance().getAllLocations(withLimit: 100, andSkip: skip) { (success, studentLocations, error) in
			if success {
				
				self.studentLocation = studentLocations
				
				// We'll use skip for testing
//				if (studentLocations?.count)! < 10 {
//					self.skip = 0 // If we received less than 10 items, reset skip to zero
//				}
//				else {
//					self.skip = self.skip + 100 // Else, skip 100 more items next time
//				}
				
				completionHandler(true, nil)
			}
			else {
				completionHandler(false, error)
			}
		}
	}
	
	// MARK: Shared Instance
	
	class func sharedInstance() -> LocationDataSource {
		struct Singleton {
			static var sharedInstance = LocationDataSource()
		}
		
		return Singleton.sharedInstance
	}
}
