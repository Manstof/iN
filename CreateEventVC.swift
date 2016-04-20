//
//  CreateEventVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Parse

class CreateEventVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate  {
    
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
    @IBOutlet weak var privateEventLabel: UILabel!
    @IBOutlet weak var eventCostLabel: UILabel!
    @IBOutlet weak var eventCostValue: UITextField!
    @IBOutlet weak var additionalDetailsLabel: UILabel!
    
    //Constraints: Image
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    //Variables
    var imageSet = false
    var lastZoomScale: CGFloat = -1
    var eventName:String = ""
    var startDatePickerHidden = true
    var endDatePickerHidden = true
    var keyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var privateEvent:Bool = false
    var detailText:String = ""
    var detailPlaceholderText:String = ""
    
    //Utility
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove Seperators in tableview from empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Set up dynamic sizing cells
        tableView.estimatedRowHeight = 34.0
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Gesture recognizer for the UIImage
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventVC.tapView(_:)))
        
        imageScrollView.addGestureRecognizer(tapRecognizer)
        
        //Set delegates
        self.eventNameLabel.delegate = self //To Dismiss Keyboard
        
        self.eventCostValue.delegate = self //To Dismiss Keyboard
        
        //Tag Text Fields
        eventNameLabel.tag = 0
        
        eventCostValue.tag = 1
        
        //Hide keyboard from Utility.swift
        self.hideKeyboardWhenTappedAround()
        
        //Get the keyboard size
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventVC.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //Setup the scrollview for the image
        imageScrollView.delegate = self
        
        imageScrollView.backgroundColor = UIColor.whiteColor()
        
        updateZoom()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // -------------------------------------------------------------------------------
    //Mark * Tableview Things
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            tableView.allowsSelection = false
            
        } else if indexPath.section == 1 && indexPath.row == 1 { //Location
            
            performSegueWithIdentifier("createEventToAddLocation", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 2 { //date picker
            
            toggleDatepicker()
        
        } else if indexPath.section == 3 && indexPath.row == 0 { //Private Event
        
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)) {
            
                cell.tintColor = globalColor.inBlue
                
                //Control Checkmark TODO: Make this a switch
                if privateEvent == false {
                
                    cell.accessoryType = .Checkmark
                    
                    privateEventLabel.textColor = UIColor.blackColor()
                    
                    privateEvent = true
                
                } else if privateEvent == true {
                    
                    cell.accessoryType = .None
                    
                    privateEventLabel.textColor = UIColor.blackColor()
                    
                    privateEvent = false
                    
                }
            }
            
        } else if indexPath.section == 3 && indexPath.row == 1 { //Cost
            
            eventCostValue.becomeFirstResponder()
            
        } else if indexPath.section == 3 && indexPath.row == 2 { //Additional Details
            
            performSegueWithIdentifier("createEventToAddDetails", sender: self)
            
        }
        
        //Scroll the selected row to the middle of the screen
        let indexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print("Section \(indexPath.section), Row \(indexPath.row)")
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if startDatePickerHidden && indexPath.section == 2 && indexPath.row == 1 {
            
            return 0
            
        } else if endDatePickerHidden && indexPath.section == 2 && indexPath.row == 3 {
            
            return 0
        
        } else if indexPath.section == 3 && indexPath.row == 2 { //Additional Detail
          
            self.view.layoutIfNeeded()
            
            return UITableViewAutomaticDimension
            
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
    
    // -------------------------------------------------------------------------------
    //MARK * Working with the imageview
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
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            
            var minZoom = min(imageScrollView.bounds.size.width / image.size.width, imageScrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 {
                
                minZoom = 1
            
                imageScrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            } else if minZoom == lastZoomScale {
                
                minZoom += 0.000001
            
                imageScrollView.zoomScale = minZoom
            
                lastZoomScale = minZoom
            
            }
        }
    }
    
    // UIScrollViewDelegate
    override func scrollViewDidZoom(scrollView: UIScrollView) {
        
        updateConstraints()
        
    }
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
        
    }
    
    //Touch recognizer. Assigned only to imageView
    func tapView (recognzier: UITapGestureRecognizer) {
        
        //TODO: Spin the activity indicator
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) { //Set source type to .camera if you want your user to be able to take a picture
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    //Process the image selected to the imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.frame = imageScrollView.frame
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageSet = true
        
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    // -------------------------------------------------------------------------------
    //MARK * Working with the keyboard
    //Get the frame of the keyboard
    func keyboardShown(notification: NSNotification) {
        
        let info  = notification.userInfo!
        
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        
        keyboardFrame = view.convertRect(rawFrame, fromView: nil)
    
    }
    
    //Dismiss the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
        self.view.endEditing(true)
        
        return false
    
    }
    
    //Scrolling the keyboard when the UITextFields are selected
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //animateViewMoving(true, moveValue: 100)
    
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    
        //animateViewMoving(true, moveValue: -100)
    
    }
 
    // -------------------------------------------------------------------------------
    //MARK * Datepicker functions
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
    
    // -------------------------------------------------------------------------------
    //MARK * Text Fields
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
            
        case 0:
            
            //IGNORE shouldChangeCharactorsInRange
            return true
            
        case 1:
            print("case 1 ran")
            // Construct the text that will be in the field if this change is accepted
            let oldText = eventCostValue.text! as NSString
            
            var newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString!
            
            var newTextString = String(newText)
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            
            var digitText = ""
            
            for c in newTextString.unicodeScalars {
                
                if digits.longCharacterIsMember(c.value) {
                    
                    digitText.append(c)
                    
                }
            }
            
            let formatter = NSNumberFormatter()
            
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            
            let numberFromField = (NSString(string: digitText).doubleValue)/100
            
            newText = formatter.stringFromNumber(numberFromField)
            
            eventCostValue.text = newText as String
            
            eventCostLabel.textColor = UIColor.blackColor()
            
        default:
        
            print("CreateEventVC did not detect the tag of the textField")
        
        }

        return false
          
    }
    
    // -------------------------------------------------------------------------------
    //MARK * Navigation
    //Unwind Segue
    @IBAction func unwindToCreateEvent (segue:UIStoryboardSegue) {
        
        if let AddLocationVC = segue.sourceViewController as? AddLocationVC {
            
            if let locationName = AddLocationVC.passedSelectedLocationName {
                
                if locationName.isEmpty == false {
                    
                    locationLabel.text = locationName
                    
                    locationLabel.textColor = UIColor.blackColor()
                    
                }
            }
            
            if let address = AddLocationVC.passedSelectedLocationAddress {
                
                if address.isEmpty == false {
                    
                    locationSubtitle.text = address
                    
                    locationSubtitle.textColor = UIColor.darkGrayColor()
                    
                }
            }
        
        } else if let AddDetailsVC = segue.sourceViewController as? AddDetailsVC {
            
            detailPlaceholderText = AddDetailsVC.placeholderText
    
            detailText = AddDetailsVC.textView.text
            
            if detailText != detailPlaceholderText {
                
                additionalDetailsLabel.text = detailText
                
                additionalDetailsLabel.textColor = UIColor.blackColor()
                
                additionalDetailsLabel.numberOfLines = 0
                
                additionalDetailsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                
                //TODO: Get this to work *WHY WONT YOU SCROLL*
                let scrollIndex = NSIndexPath(forRow: 3, inSection: 3)
                
                tableView.scrollToRowAtIndexPath(scrollIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                
            }
        }
    }
    
    //Passing Data to other VC's
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "createEventToAddDetails" {
        
            if let destinationVC = segue.destinationViewController as? AddDetailsVC {
                
                destinationVC.placeholderText = detailText
                
                print(detailText)
            }
        }
    }
    
    //Navigating to invite guests screen
    @IBAction func nextTableButton(sender: AnyObject) {
    
    
    }
    
    @IBAction func nextBarButton(sender: AnyObject) {
    
    
    }
    
}

//TODO Eventually make a slacktext keyboard for the user to use.

//TODO Add cost information

