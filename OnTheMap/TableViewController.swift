//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/9/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
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
	}
	
	@IBAction func refresh(_ sender: AnyObject) {
		LocationDataSource.sharedInstance().refresh { (success, error) in
			if success {
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}

	// MARK: UITableViewDataSource Methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if let dataSource = LocationDataSource.sharedInstance().studentLocation {
			return dataSource.count
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
		let location = LocationDataSource.sharedInstance().studentLocation![indexPath.row]
		
		cell.imageView?.image = #imageLiteral(resourceName: "Pin")
		cell.textLabel?.text = "\(location.firstName) \(location.lastName)"

		return cell
	}

	// MARK: UITableViewDelegate Methods
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let mediaURL = LocationDataSource.sharedInstance().studentLocation![indexPath.row].mediaURL
		
		UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
		
		// Change the selected background view of the cell.
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
