//®
//  CreateEventVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Firebase



class CreateEventVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    //UI Elements
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationSubtitle: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var privateEventLabel: UILabel!
    @IBOutlet weak var openEventSwitch: UISwitch!
    @IBOutlet weak var eventCostLabel: UILabel!
    @IBOutlet weak var eventCostField: UITextField!
    @IBOutlet weak var additionalDetailsLabel: UILabel!

    //Constraints: Image
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    //Variables
    var imageSet: Bool = false
    var lastZoomScale: CGFloat = -1
    var startDatePickerHidden: Bool = true
    var endDatePickerHidden: Bool = true
    var activeField: UITextField?
    var unwindSender: String = ""
    
    //Firebase
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove seperators in tableView from empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Set up self sizing cells
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Tap gesture recognizer for the UIImage
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventVC.tapView(_:)))
        
        imageScrollView.addGestureRecognizer(tapRecognizer)
        
        //Set delegates for textFields
        self.eventNameField.delegate = self //To Dismiss Keyboard
        self.eventCostField.delegate = self //To Dismiss Keyboard
        
        //Set tags for textFields
        eventNameField.tag = 0
        eventCostField.tag = 1
        
        //Hide keyboard from Utility.swift
        self.hideKeyboardWhenTappedAround()
        
        //Adding the done button to the number keyboard
        self.addDoneButtonOnKeyboard(eventCostField)
        
        //Set intervals on pickers
        startDatePicker.minuteInterval = 10
        endDatePicker.minuteInterval = 10
        
        //Setup switch
        //openEventSwitch.addTarget(self, action: #selector(CreateEventVC.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        openEventSwitch.tintColor = globalColor.inBlue
        openEventSwitch.onTintColor = globalColor.inBlue
        
        //Firebase TODO Make this better
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if let user = user {
            
                event.info.hostUID = user.uid //TODO make this the username in lieu of id?
            
            } else {
                
                // No user is signed in.
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //Scroll based upon which unwind segue presented the controller
        if unwindSender == "AddLocationVC" {
            
            let indexPath = NSIndexPath(forRow: 1, inSection: 1)
            
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
            
        } else if unwindSender == "InviteGuestsVC" {
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 3)
            
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
            
        } else if unwindSender == "AddDetailsVC" {
            
            let indexPath = NSIndexPath(forRow: 3, inSection: 3)
            
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
            
        } else {
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            
        }
        
        //Register keyboard for notifications from Utility.swift
        registerForKeyboardNotifications()
        
        //Setup the scrollview for the image
        imageScrollView.delegate = self
        
        imageScrollView.backgroundColor = UIColor.whiteColor()
        
        updateZoom()
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Deregister keyboard for notifications from Utility.swift
        deregisterFromKeyboardNotifications()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ tableView ═══╬
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 1 { //Location
            
            performSegueWithIdentifier("createEventToAddLocation", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 2 { //Datepicker
            
            toggleDatepicker()
        
        } else if indexPath.section == 3 && indexPath.row == 0 { //Invite Friends
            
            performSegueWithIdentifier("createEventToInviteGuests", sender: self)
            
        } else if indexPath.section == 3 && indexPath.row == 1 { //Privacy
            
            switchIsChanged(openEventSwitch)
            
        } else if indexPath.section == 3 && indexPath.row == 2 { //Cost
            
            eventCostField.becomeFirstResponder()
            
        } else if indexPath.section == 3 && indexPath.row == 3 { //Additional Details
            
            performSegueWithIdentifier("createEventToAddDetails", sender: self)
            
        }
        
        //Scroll the selected row to the middle of the screen
        let indexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print("Section \(indexPath.section), Row \(indexPath.row)")
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {  //Photo Picker
            
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        } else if startDatePickerHidden && indexPath.section == 2 && indexPath.row == 1 {  //Start Datepicker
            
            return 0
            
        } else if endDatePickerHidden && indexPath.section == 2 && indexPath.row == 3 {  //End Datepicker
            
            return 0
        
        } else if indexPath.section == 3 && indexPath.row == 3 { //Additional Detail
            
            if event.info.additionalDetails == "" {
                
                return 50
                
            } else {
            
                return UITableViewAutomaticDimension
            
            }
            
        } else { //All Other Cells
        
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = UIColor.whiteColor()
        
        header.contentView.backgroundColor = globalColor.inBlue
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionHeight: CGFloat = 5
        
        switch section {
            
        case 0:
            
            return 0
            
        default:
            
            return sectionHeight
        
        }
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ imageView ═══╬
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ [weak self] _ in self?.updateZoom() },completion: nil)
        
    }
    
    func updateConstraints() {
        
        if let image = imageView.image {
            
            let imageWidth = image.size.width
            
            let imageHeight = image.size.height
            
            let viewWidth = imageScrollView.bounds.size.width
            
            let viewHeight = imageScrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - imageScrollView.zoomScale * imageWidth) / 2
            
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - imageScrollView.zoomScale * imageHeight) / 2
            
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        
        }
    }
    
    //Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        
        if let image = imageView.image {
            
            var minZoom = min(imageScrollView.bounds.size.width / image.size.width, imageScrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 {
                
                minZoom = 1
            
                imageScrollView.minimumZoomScale = minZoom
            
            //Force scrollViewDidZoom fire if zoom did not change
            } else if minZoom == lastZoomScale {
                
                minZoom += 0.000001
            
                imageScrollView.zoomScale = minZoom
            
                lastZoomScale = minZoom
            
            }
        }
    }
    
    //UIScrollViewDelegate
    override func scrollViewDidZoom(scrollView: UIScrollView) {
        
        updateConstraints()
        
    }
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
        
    }
    
    //Touch recognizer for imageView
    func tapView (recognzier: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) { //Set source type to .camera if you want your user to be able to take a picture
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        
        lastZoomScale = -1
        
    }
    
    //Process the image selected to the imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.bounds = imageScrollView.bounds
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.clipsToBounds = false
        
        imageSet = true
        
        view.layoutIfNeeded()
        
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Keyboard ═══╬
    
    func keyboardWasShown(notification: NSNotification) {
        
        //Calculate the keyboard size and adjust the tableView
        let info : NSDictionary = notification.userInfo!
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        tableView.contentInset = contentInsets
        
        //Scroll if the firstResponder is behind the keyboard
        var viewRect : CGRect = self.view.frame
        
        viewRect.size.height -= keyboardSize!.height
        
        if (!CGRectContainsPoint(viewRect, activeField!.frame.origin)) {
                
            tableView.scrollRectToVisible(activeField!.frame, animated: true)
            
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        //Once keyboard disappears, restore original positions of the view
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        
        let navigationBarHeight = navigationController!.navigationBar.frame.size.height

        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(navigationBarHeight, 0.0, tabBarHeight, 0.0)

        tableView.contentInset = contentInsets
        
        self.view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeField = textField //Passes to keyboardWasShown to identify textField
    
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeField = nil //Passes to keyboardWasShown to deselect textField
    
    }
    
    //Dismiss the keyboard on return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        self.view.endEditing(true)
        
        return false
    
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        //Resign responders to get rid of BS "error"
        eventCostField.resignFirstResponder()
        
        eventNameField.resignFirstResponder()
        
    }
    
    //Adding a toolbar to the number keyboard
    //a slightly more generalized solution based on above
    //TODO: Move to a different file
    func addDoneButtonOnKeyboard(view: UIView?) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, tableView.bounds.size.width, 50))
        
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: view, action: #selector(UIResponder.resignFirstResponder))
        
        var items = [UIBarButtonItem]()
        
        items.append(flexSpace)
        
        items.append(done)
       
        doneToolbar.items = items
        
        doneToolbar.sizeToFit()
        
        if let accessorizedView = view as? UITextField {
        
            accessorizedView.inputAccessoryView = doneToolbar
            
            accessorizedView.inputAccessoryView = doneToolbar
        
        }
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Datepicker ═══╬
    
    func toggleDatepicker() {
        
        let section = self.tableView.indexPathForSelectedRow!.section
        
        let row = self.tableView.indexPathForSelectedRow!.row
        
        if section == 2 && row == 0 {
            
            startDatePickerHidden = !startDatePickerHidden
            
            endDatePickerHidden = true
            
        } else if section == 2 && row == 2  {
            
            endDatePickerHidden = !endDatePickerHidden
            
            startDatePickerHidden = true
            
        }
        
        tableView.beginUpdates()
     
        tableView.endUpdates()
        
    }
    
    //Actions from UI element date picker
    @IBAction func datePickerValue(sender: UIDatePicker) {
     
        datePickerChanged()
    
    }
    
    func datePickerChanged () {
        
        startDateLabel.textColor = UIColor.blackColor()
        
        endDateLabel.textColor = UIColor.blackColor()
        
        startDateDetailLabel.text = NSDateFormatter.localizedStringFromDate(startDatePicker.date, dateStyle:NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        endDateDetailLabel.text = NSDateFormatter.localizedStringFromDate(endDatePicker.date, dateStyle:NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        if startDatePicker.date.isGreaterThanDate(endDatePicker.date) {
            
            endDatePicker.date = startDatePicker.date
            
            endDateDetailLabel.text = NSDateFormatter.localizedStringFromDate(startDatePicker.date, dateStyle:NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            
        }
        
        event.info.startDateString = NSDateFormatter.localizedStringFromDate(startDatePicker.date, dateStyle:NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        event.info.endDateString = NSDateFormatter.localizedStringFromDate(endDatePicker.date, dateStyle:NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Contacts ═══╬
    /*
    func findContacts() -> [CNContact] {
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                           CNContactImageDataKey,
                           CNContactPhoneNumbersKey]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers != nil")
        
        contactPickerViewController.delegate = self
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
        
        
    }
    */
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ event privacy switch ═══╬
    
    func switchIsChanged(openEventSwitch: UISwitch) {
        
        if openEventSwitch.on {
        
            privateEventLabel.text = "Private Event"
            
            openEventSwitch.setOn(false, animated: true)
            
            event.info.open = true
        
        } else {
            
            privateEventLabel.text = "Open Event"
        
            openEventSwitch.setOn(true, animated: true)
            
            event.info.open = false
            
        }
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ textFields ═══╬
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch UITextField() {
            
        case eventCostField: break
            
        default:
            
            print("Maybe")
            
        }
        
        
        switch textField.tag {
            
        case 0:
            
            //Set the number of charactors accepted in the textField
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 30
            
        case 1:
            
            //Create textField that only accepts numbers and is formatted for $
            let oldText = eventCostField.text! as NSString
            
            var newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString!
            
            var newTextString = String(newText)
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            
            var digitText = ""
            
            for charactor in newTextString.unicodeScalars {
                
                if digits.longCharacterIsMember(charactor.value) {
                    
                    digitText.append(charactor)
                    
                }
            }
            
            let formatter = NSNumberFormatter()
            
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            
            let numberFromField = (NSString(string: digitText).doubleValue)/100
            
            newText = formatter.stringFromNumber(numberFromField)
            
            if newText.length <= 13 {
                
                eventCostField.text = newText as String
                
                eventCostField.textColor = UIColor.blackColor()
                
                event.info.cost = eventCostField.text
                
            }
            
        default:
        
            print("CreateEventVC textField tag not recognized")
        
        }

        return false
          
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ Navigation ═══╬
    
    //TODO Prepare for segue to stop activity indicator
    
    //Unwind
    @IBAction func unwindToCreateEvent (segue:UIStoryboardSegue) {
        
        //Working with AddLocationVC data
        if event.info.locationName != "" && event.info.locationAddress != "" {
            
            locationLabel.text = event.info.locationName
            
            locationLabel.textColor = UIColor.blackColor()
            
            locationSubtitle.text = event.info.locationAddress
            
            locationSubtitle.textColor = UIColor.darkGrayColor()
            
            unwindSender = "AddLocationVC"
        
        }
        
        //Working with InviteGuestsVC
        if event.info.guests.count >= 1 {
            
            //TODO something Pretty
            guestsLabel.text = "\(event.info.guests.count) Guests Invited"
            
            guestsLabel.textColor = UIColor.blackColor()
            
            guestsLabel.numberOfLines = 0
            
            guestsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
           
            unwindSender = "InviteGuestsVC"
            
        }
        
        //Working with AddDetailsVC data
        if event.info.additionalDetails != "" {
                
            additionalDetailsLabel.text = event.info.additionalDetails
                
            additionalDetailsLabel.textColor = UIColor.blackColor()
                
            additionalDetailsLabel.numberOfLines = 0
            
            additionalDetailsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            //Set the scroll location in the viewDidAppear
            unwindSender = "AddDetailsVC"
        
        }
    }
    
    @IBAction func nextBarButton(sender: AnyObject) {
        
        //TODO Verify all the information that the user input
        
        //event.info.host = Current User
        event.info.name = eventNameField.text
        
        //Structure event data
        let createdEvents = ["eventHostUID": event.info.hostUID,
                             "eventCreated": timestamp,
                             "eventName": event.info.name,
                             "eventLocationName": event.info.locationName,
                             "eventLocationAddress": event.info.locationAddress,
                             "eventStartDate": event.info.startDateString,
                             "eventEndDate": event.info.endDateString,
                             "eventGuests": event.info.guests.count,
                             "eventOpen": event.info.open,
                             "eventCost": event.info.cost,
                             "eventAdditionalDetails": event.info.additionalDetails]
        
        let eventID = "\(event.info.hostUID)-\(timestamp)"
        
        //save to events tree
        let firebaseEventKey = ref.child("events").child(eventID)
        
        firebaseEventKey.setValue(createdEvents)
        
        //Save the event to the users tree
        let firebaseUserEventKey = ref.child("users").child(event.info.hostUID).child("usersEvents").child(eventID)
        
        firebaseUserEventKey.setValue(createdEvents)
        
        //Working with guests
        var guestCount = 1
        
        for guest in event.info.guests {
            
            //TODO Check if user exists
            
            //Format phone number
            var formattedPhoneNumber = ""
            
            for number in guest.phoneNumbers {
                
                if number.label == "_$!<Mobile>!$_" {
                    
                    let phoneNumber = number.value as! CNPhoneNumber
                    
                    formattedPhoneNumber = phoneFormatter(phoneNumber.stringValue)
                    
                }
            }
            
            //Format user picture
            var imageBase64String = ""
            
            if guest.imageData != nil {
                
                let imageData = guest.imageData
                
                imageBase64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
            }
            
            //Save Guest Information
            let eventGuest = ["name": guest.givenName + " " + guest.familyName,
                              "phoneNumber": formattedPhoneNumber,
                              "imageBase64String": imageBase64String]
            
            
            //TODO: Make this the users handle
            firebaseEventKey.child("eventGuests").child("guest \(guestCount)").updateChildValues(eventGuest)
            
            guestCount += 1
        }
        
        /*
        print("Event Name: \(event.info.name)")
        print("Event Location Name: \(event.info.locationName)")
        print("Event Location Address: \(event.info.locationAddress)")
        print("Event Start Date: \(event.info.startDate)")
        print("Event End Date: \(event.info.endDate)")
        print("Guest Count: \(event.info.guests.count)")
        print("Event Open: \(event.info.open)")
        print("Event Cost: \(event.info.cost)")
        print("Event Additional Details: \(event.info.additionalDetails)")
        */
    }
    
}

//TODO Eventually make a slacktext keyboard for the user to use.
