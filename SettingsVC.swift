//
//  SettingsVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    var sectionTitles = ["Account Settings", "Information", "Follow Us", ""]
    var sectionContent = [["Edit Profile", "Friends", "Payment Methods"], ["About", "Tutorial", "FAQ", "Privacy Policy", "Feedback"], ["Twitter", "Facebook", "Pinterest"]]
    
    //"Edit Profile", "Friends", "Get Friends iN", "About", "Payment Method", "Privacy Policy", "FAQ", "Tutorial", "Feedback", "Logout"
    
    //Setup finding the size of the screen
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sectionTitles.count
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            
            return sectionContent[0].count
            
        case 1:
            
            return sectionContent[1].count
            
        case 2:
            
            return sectionContent[2].count
            
        case 3:
            
            return 1 //Return empty cell
            
        default:
            
            return 0
            
        }
        
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
        
    }
    
    /*override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")
        
        headerCell!.backgroundColor = UIColor.cyanColor()
        
        return headerCell
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Set the screen size and screen width
        let screenWidth = screenSize.width
        
        //let screenHeight = screenSize.height
        
        //Setting up the cells
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SettingsCell
        
        switch indexPath.section {
            
        case 0:
            
            cell.cellLabel.text = sectionContent[indexPath.section][indexPath.row]
            
            break;
            
        case 1:
            
            cell.cellLabel.text = sectionContent[indexPath.section][indexPath.row]
            
            break;
            
        case 2:
            
            cell.cellLabel.text = sectionContent[indexPath.section][indexPath.row]
            
            break;
            
        case 3:
            
            tableView.rowHeight = 60
            
            cell.cellLabel.text = ""
            
            let logoutButton = UIButton(type: UIButtonType.Custom) as UIButton
            
            logoutButton.backgroundColor = globalColor.inBlue
            
            logoutButton.setTitle("Logout", forState: UIControlState.Normal)
            
            logoutButton.frame = CGRectMake(0, 0, screenWidth, 60)
            
            logoutButton.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: UIControlEvents.TouchUpInside) //Figure out how to do this
            
            logoutButton.tag = indexPath.row
            
            cell.contentView.addSubview(logoutButton)
            
            break;
            
        default:
            
            break;
            
        }

        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 {
            
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
