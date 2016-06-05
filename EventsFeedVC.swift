//
//  EventsVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Firebase


class EventsFeedVC: UITableViewController {
    
    var eventRef: FIRDatabaseReference!
    
    let ref = FIRDatabase.database().reference()
    
    var eventCellArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Eliminate the title of the back button when navigating to different views
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
    }

    override func viewWillAppear(animated: Bool) {
        
        eventCellArray.removeAll()
        
        loadUsersEvents()
        
    }
    
    func loadUsersEvents() {
        
        //Firebase
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if let user = user {
                
                self.ref.child("users").child(user.uid).child("usersEvents").observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if snapshot.exists() {
                        
                        let child = snapshot.children
                        
                        while let childSnapshot = child.nextObject() as? FIRDataSnapshot {
                            
                            if childSnapshot.exists() {
                                
                                let eventSnapshot = childSnapshot.value as! NSDictionary
                                
                                //event.info.name = eventSnapshot.valueForKey("eventName") as! String
                                
                                self.eventCellArray.append(eventSnapshot)
                                
                                print(self.eventCellArray)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                })
                
            } else {
                
                // No user is signed in.
            
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventCellArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EventsFeedCell
        
        print(eventCellArray[indexPath.row])
        
        cell.nameLabel.text = eventCellArray[indexPath.row]["eventName"] as? String
        
        cell.hostLabel.text = eventCellArray[indexPath.row]["eventHostUID"] as? String
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
