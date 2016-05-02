//
//  InviteFriendsVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Parse
import Contacts
import ContactsUI

class InviteGuestsVC: UITableViewController, CNContactPickerDelegate {

    var contacts = [CNContact]()
    var invitedContacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load contacts
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            self.contacts = self.findContacts()
            
            dispatch_async(dispatch_get_main_queue()) {
            
                self.tableView!.reloadData()
            
            }
        }
        
        invitedContacts = event.info.guests
        
        //TODO put letter scroll bar on the side
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ tableView ═══╬
    
    //TODO create another section that displays the favories or added contacts
    //TODO add a header section for letter of contacts name
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! InviteGuestCell
        
        let contact = contacts[indexPath.row] as CNContact
        
        //Set Name
        cell.contactNameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        //Set Phone Number
        if let phoneNumberLabel = cell.contactNumberLabel {
        
            var numberArray = [String]()
            
            for number in contact.phoneNumbers {
                
                if number.label == "_$!<Mobile>!$_" {
                    
                    let phoneNumber = number.value as! CNPhoneNumber
                    
                    let formattedPhoneNumber = phoneFormatter(phoneNumber.stringValue)
                    
                    numberArray.append(formattedPhoneNumber)
                    
                }
            }
            
            //TODO fix this, we only wanna use one number not two
            phoneNumberLabel.text = numberArray.joinWithSeparator(", ")
        }
        
        //TODO Figure out a way to load the proper contact each time
        //Set image for cells
        if contact.imageData != nil {
            
            let buttonImage = cell.contactImageButton
            
            buttonImage.setImage(UIImage(data: contact.imageData!), forState: .Normal)
            
            buttonImage.contentMode = .ScaleAspectFit
            
            buttonImage.layer.borderWidth = 1
            
            buttonImage.layer.masksToBounds = false
            
            buttonImage.layer.borderColor = globalColor.inBlue.CGColor
            
            buttonImage.layer.cornerRadius = buttonImage.frame.height/2
            
            buttonImage.clipsToBounds = true

        } else if contact.givenName.isEmpty == false && contact.familyName.isEmpty == false {
                
            let firstInitial = contact.givenName.substringToIndex(contact.givenName.startIndex.advancedBy(1))
                
            let lastInitial = contact.familyName.substringToIndex(contact.familyName.startIndex.advancedBy(1))
                
            let guestInitials = firstInitial + lastInitial
                
            cell.contactImageButton.backgroundColor = UIColor.whiteColor()
                
            cell.contactImageButton.setTitle(guestInitials, forState: .Normal)
                
            cell.contactImageButton.layer.borderWidth = 1
                
            cell.contactImageButton.layer.borderColor = globalColor.inBlue.CGColor
                
            cell.contactImageButton.layer.cornerRadius = cell.contactImageButton.frame.height/2
            
            cell.contactImageButton.clipsToBounds = true
            
        }

        //Set checkmark for selected guests
        if invitedContacts.contains(contact) {
            
            cell.accessoryType = .Checkmark
            
        } else {
            
            cell.accessoryType = .None
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return 80
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let contact = contacts[indexPath.row] as CNContact
        
        if invitedContacts.contains(contact) {
            
            //TODO create custom accessory type
            cell!.accessoryType = .None
            
            invitedContacts.removeObject(contact)
            
        } else {
            
            cell!.accessoryType = .Checkmark
            
            invitedContacts.append(contact)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print("Selected: Section \(indexPath.section), Row \(indexPath.row)")
        
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ functions ═══╬

    func findContacts() -> [CNContact] {
        
        let store = CNContactStore()
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                           CNContactImageDataKey,
                           CNContactPhoneNumbersKey]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        fetchRequest.sortOrder = CNContactSortOrder.UserDefault
        
        var contacts = [CNContact]()
        
        do {
            
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
                
                if contact.givenName.isEmpty == false && contact.phoneNumbers.isEmpty == false && contact.phoneNumbers.description.containsString("Mobile") {
                    
                    contacts.append(contact)
                
                }
            })
        }
            
        catch let error as NSError {
            
            print(error.localizedDescription)
            
        }
        
        return contacts
    }
    
    // MARK: - Segues
    //Unwind segue back to the createEventVC screen
    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        event.info.guests = invitedContacts
                
        performSegueWithIdentifier("unwindInviteGuestsToCreateEvent", sender: self)
        
    }

}