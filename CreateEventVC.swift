//
//  CreateEventVC.swift
//  iN
//
//  Created by Mark Manstof on 3/22/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Parse

class CreateEventVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {
    
    //UI Elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateDetailLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var detailsTextView: UITextView!
    
    //Variables
    var imageSet = false
    var eventName:String = ""
    var startDatePickerHidden = true
    var endDatePickerHidden = true
    var detailTextViewHasChanged = false
    var keyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //Utility
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove Seperators from empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Gesture recognizer for the UIImage
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventVC.tapView(_:)))
        
        //let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CreateEventVC.panView(_:)))
        
        //let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CreateEventVC.pinchView(_:)))
        
        //Add the pan recognizer to your view.
        imageView.addGestureRecognizer(tapRecognizer)
        
        //imageView.addGestureRecognizer(panRecognizer)
        
        //imageView.addGestureRecognizer(pinchRecognizer)
        
        //Track text view changes
        detailsTextView.delegate = self
        
        //Hide keyboard from Utility.swift
        self.hideKeyboardWhenTappedAround()
        
        //Get the keyboard size
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventVC.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            tableView.allowsSelection = false
            
        } else if indexPath.section == 2 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 2 {
            
            toggleDatepicker()
        
        //Select the add location cell
        } else if indexPath.section == 3 && indexPath.row == 0 {
            
            performSegueWithIdentifier("createEventToAddLocation", sender: self)
           
        }
        
        print("Section \(indexPath.section), Row \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //Setting datePicker rows height
        if startDatePickerHidden && indexPath.section == 2 && indexPath.row == 1 {
            
            return 0
            
        } else if endDatePickerHidden && indexPath.section == 2 && indexPath.row == 3 {
            
            return 0
        
        } else if  indexPath.section == 4 && indexPath.row == 0 {
            
            if detailTextViewHasChanged == false {
            
                return 200
                
            } else {
                
                self.view.layoutIfNeeded()
                
                return UITableViewAutomaticDimension
                
            }
        
        } else {
        
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    //MARK * Process the image selected to the imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageSet = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Touch recognizer. Assigned only to imageView
    func tapView (recognzier: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) { //Set source type to .camera if you want your user to be able to take a picture
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        
        }
        
    }
    /*
    //Pan recognizer.  Assigned only to imageView
    func panView (recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        
        if let panView = recognizer.view {
        
            panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
        
        }
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
    
    }
    
    //Pinch gesture recognizer.  Assigned only to imageView.
    func pinchView (sender: UIPinchGestureRecognizer){
        
        if imageView.bounds.height < imageView.frame.height && imageView.bounds.width < imageView.frame.width {
            
            sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
            
            sender.scale = 1
            
        } else if sender.scale > 1 {  //Could I add another statement here if the user shrinks the image too fast?
            
            sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
            
            sender.scale = 1
            
        }
        
        print("Bounds: Height: \(imageView.bounds.height), Width: \(imageView.bounds.width)")
        print("Image: Height: \(imageView.frame.height.hashValue), Width:\(imageView.frame.width), Center\(imageView.center)")
    
    }
    */
    
    //MARK * Working with the keyboard
    //Get the frame of the keyboard
    func keyboardShown(notification: NSNotification) {
        
        let info  = notification.userInfo!
        
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        
        keyboardFrame = view.convertRect(rawFrame, fromView: nil)
    
    }
    
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
    
    //Autosizing the text view based on text view
    @IBAction func textViewDidChange(detailsTextView: UITextView) {
        
        //Working with the textview sizing
        detailTextViewHasChanged = true
        
        tableView.estimatedRowHeight = 200
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Disable the animations
        UIView.setAnimationsEnabled(false)
        
        CATransaction.begin()
        
        //Set the completion block of the animation
        CATransaction.setCompletionBlock { () -> Void in
        
            UIView.setAnimationsEnabled(true)
        
        }
        
        //Working with the textview position
        //let screenHeight = screenSize.height
        //print("Y of Cell is: \(rectOfCellInSuperview.origin.y)")
        //print(self.tableView.contentOffset.y)
        
        //Update the table
        self.tableView.beginUpdates()
        
        self.tableView.endUpdates()
        
        // Commit the animation
        CATransaction.commit()
        
    }
    
    //MARK * Navigation
    //Unwind Segue
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    
    }
    
    //Navigating to invite guests screen
    @IBAction func nextTableButton(sender: AnyObject) {
    
    
    }
    
    @IBAction func nextBarButton(sender: AnyObject) {
    
    
    }
    
}

//TODO Eventually make a slacktext keyboard for the user to use.