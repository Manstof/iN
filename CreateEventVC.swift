//®
//  CreateEventVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Parse
import Contacts
import ContactsUI

class CreateEventVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, CNContactPickerDelegate {
    
    //UI Elements
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationSubtitle: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var privateEventLabel: UILabel!
    @IBOutlet weak var privateEventSwitch: UISwitch!
    @IBOutlet weak var eventCostLabel: UILabel!
    @IBOutlet weak var eventCostValue: UITextField!
    @IBOutlet weak var additionalDetailsLabel: UILabel!
    
    //Constraints: Image
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    //Variables
    var imageSet:Bool = false
    var lastZoomScale: CGFloat = -1
    var startDatePickerHidden:Bool = true
    var endDatePickerHidden:Bool = true
    var detailText:String = ""
    var detailPlaceholderText:String = ""
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove seperators in tableView from empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Set up self sizing cells
        tableView.estimatedRowHeight = 60.0
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Tap gesture recognizer for the UIImage
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventVC.tapView(_:)))
        
        imageScrollView.addGestureRecognizer(tapRecognizer)
        
        //Set delegates for textFields
        self.eventNameLabel.delegate = self //To Dismiss Keyboard
        
        self.eventCostValue.delegate = self //To Dismiss Keyboard
        
        //Set tags for textFields
        eventNameLabel.tag = 0
        
        eventCostValue.tag = 1
        
        //Hide keyboard from Utility.swift
        self.hideKeyboardWhenTappedAround()
        
        //Adding the done button to the number keyboard
        self.addDoneButtonOnKeyboard(eventCostValue)
        
        //Setup switch
        privateEventSwitch.addTarget(self, action: #selector(CreateEventVC.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        privateEventSwitch.tintColor = globalColor.inBlue
        
        privateEventSwitch.onTintColor = globalColor.inBlue
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
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
        
        if indexPath.section == 0 && indexPath.row == 0 { //Image
            
            //Do Nothing
            
        } else if indexPath.section == 1 && indexPath.row == 1 { //Location
            
            performSegueWithIdentifier("createEventToAddLocation", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 2 { //Datepicker
            
            toggleDatepicker()
        
        } else if indexPath.section == 3 && indexPath.row == 0 { //Invite Friends
            
            //findContacts()
            
            performSegueWithIdentifier("createEventToInviteGuests", sender: self)
            
        } else if indexPath.section == 3 && indexPath.row == 1 { //Privacy
            
            switchIsChanged(privateEventSwitch)
        
            /*
            if privateEventSwitch.on == true {
              
                privateEventSwitch.setOn(false, animated: true)
                
            } else if privateEventSwitch.on == false {
                
                privateEventSwitch.setOn(true, animated: true)
                
            }
            */
 
            //privateEventSwitch.on = !privateEventSwitch.on
            
        } else if indexPath.section == 3 && indexPath.row == 2 { //Cost
            
            eventCostValue.becomeFirstResponder()
            
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
        
        if startDatePickerHidden && indexPath.section == 2 && indexPath.row == 1 {  //Start Datepicker
            
            return 0
            
        } else if endDatePickerHidden && indexPath.section == 2 && indexPath.row == 3 {  //End Datepicker
            
            return 0
        
        } else if indexPath.section == 3 && indexPath.row == 3 { //Additional Detail
            
            if event.info.additionalDetails == event.info.additionalDetailsPlaceholder {
                
                return 60
                
            } else {
            
                return UITableViewAutomaticDimension
            
            }
            
        } else {
        
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = UIColor.whiteColor()
        
        header.contentView.backgroundColor = globalColor.inBlue
        
        //TODO: Set the size of the header views that are displayed
        
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
        
        //Resign responders to get rid of error
        eventCostLabel.resignFirstResponder()
        
        eventNameLabel.resignFirstResponder()
        
    }
    
    //Adding a toolbar to the number keyboard
    //a slightly more generalized solution based on above
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
        
        //This is where you save the event information
        //let eventStart = startDatePicker.date
        
        //let eventEnd = endDatePicker.date
        
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
    
    func switchIsChanged(privateEventSwitch: UISwitch) {
        
        if privateEventSwitch.on {
        
            privateEventLabel.text = "Public Event"
            
            privateEventSwitch.setOn(false, animated: true)
            
            event.info.open = true
        
        } else {
            
            privateEventLabel.text = "Private Event"
        
            privateEventSwitch.setOn(true, animated: true)
            
            event.info.open = false
            
        }
    }
    
    // █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █ ▄ █ ▄ █ ▄ █ ▄ ▄ █
    // -------------------------------------------------------------------------------
    // ╬═══ MARK ═ textFields ═══╬
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
            
        case 0:
            
            //Set the number of charactors accepted in the textField
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 30
            
        case 1:
            
            //Create textField that only accepts numbers and is formatted for $
            let oldText = eventCostValue.text! as NSString
            
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
                
                eventCostValue.text = newText as String
                
                eventCostLabel.textColor = UIColor.blackColor()
                
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
        
        }
        
        //Working with InviteGuestsVC
        if event.info.guests.count >= 1 {
            
            //TODO something Pretty
            contactsLabel.text = "\(event.info.guests.count) guests invited"
            
            contactsLabel.textColor = UIColor.blackColor()
            
            contactsLabel.numberOfLines = 0
            
            contactsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
        }
        
        //Working with AddDetailsVC data
        if event.info.additionalDetails != event.info.additionalDetailsPlaceholder {
                
            additionalDetailsLabel.text = event.info.additionalDetails
                
            additionalDetailsLabel.textColor = UIColor.blackColor()
                
            additionalDetailsLabel.numberOfLines = 0
            
            additionalDetailsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            //TODO get scroll to work when presenting the viewcontroller
            tableView.scrollRectToVisible(additionalDetailsLabel.frame, animated: true)
        
        }
    }
    
    @IBAction func nextBarButton(sender: AnyObject) {
    
        event.info.name = eventNameLabel.text
        
        print("Event Name: \(event.info.name)")
        print("Event Location Name: \(event.info.locationName)")
        print("Event Location Address: \(event.info.locationAddress)")
        print("Event Start Date: \(event.info.startDate)")
        print("Event End Date: \(event.info.endDate)")
        print("Guest Count: \(event.info.guests.count)")
        print("Event Open: \(event.info.open)")
        print("Event Cost: \(event.info.cost)")
        print("Event Additional Details: \(event.info.name)")
        
    }
    
}

//TODO Eventually make a slacktext keyboard for the user to use.
