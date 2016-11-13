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
		
		performTableDataRefresh()
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

		Utility.launchingView = .TableView
		
		// If the user has already posted before, simply ask them for overwrite permission
		if let _ = ParseClient.sharedInstance().overwriteObjectId {
			Utility.displayAlertForOverwrite(viewController: self, triggerSegueIdentifier: "TableViewToPostLocationViewSegue")
		}
		else {
			// Else, try and get old locations from Parse
			ParseClient.sharedInstance().getCurrentUserLocations() { (success, locations, error) in
				if success && locations!.count > 0 {
					ParseClient.sharedInstance().overwriteObjectId = locations![0].objectId
					Utility.displayAlertForOverwrite(viewController: self, triggerSegueIdentifier: "TableViewToPostLocationViewSegue")
				}
				else {
					DispatchQueue.main.async {
						self.performSegue(withIdentifier: "PostLocationViewSegue", sender: self)
					}
				}
			}
		}

	}
	
	@IBAction func refresh(_ sender: AnyObject) {
		performTableDataRefresh()
	}
	
	@IBAction func unwindToTableView(segue: UIStoryboardSegue) {}

	// MARK: UITableViewDataSource Methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if let dataSource = LocationDataSource.sharedInstance().studentLocations {
			return dataSource.count
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
		let location = LocationDataSource.sharedInstance().studentLocations![indexPath.row]
		
		cell.imageView?.image = #imageLiteral(resourceName: "Pin")
		cell.textLabel?.text = "\(location.firstName) \(location.lastName)"

		return cell
	}

	// MARK: UITableViewDelegate Methods
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let mediaURL = LocationDataSource.sharedInstance().studentLocations![indexPath.row].mediaURL
		
		UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
		
		// Change the selected background view of the cell.
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	fileprivate func performTableDataRefresh() {
		Utility.refreshLocationDataSource() { (success, error) in
			DispatchQueue.main.async {
				if success {
					self.tableView.reloadData()
				}
				else {
					Utility.displayErrorAlert(inViewController: self, withMessage: error!)
				}
			}
		}
	}
}
