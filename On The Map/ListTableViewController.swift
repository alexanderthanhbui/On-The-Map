//
//  ListTableViewController.swift
//  On The Map
//
//  Created by Hayne Park on 11/10/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getStudentLocation{ (results) -> () in
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        Client.sharedInstance().logoutSession { (success, errorString) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    func getStudentLocation(completionHandler handler:@escaping ([[String:AnyObject]]) -> Void) {
        Client.sharedInstance().getStudentLocations { (results, errorString) in
            if(results != nil) {
                print("works")
            } else {
                let alertController = UIAlertController(title: "Download Fail", message: "Unable to download student locations", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.sharedInstance.studentLocationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! CustomTableViewCell

        // Configure the cell...
        let location = StudentLocation.sharedInstance.studentLocationList[indexPath.row]

        cell.customLabel.text = location.firstName! + " " + location.lastName!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = StudentLocation.sharedInstance.studentLocationList[indexPath.row]

        let app = UIApplication.shared
        if let toOpen = location.mediaURL {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: { (nil) in
                print("works")
            })
        }
    }
}
