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
    @IBOutlet weak var detailsTextView: UITextView!
    
    //Constraints
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
    var detailTextViewHasChanged = false
    var keyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //Utility
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove Seperators in tableview from empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Gesture recognizer for the UIImage
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEventVC.tapView(_:)))
        
        imageScrollView.addGestureRecognizer(tapRecognizer)
        
        //Set delegate for text fields so they dismiss the keyboard
        self.eventNameLabel.delegate = self
        
        //Hide keyboard from Utility.swift
        self.hideKeyboardWhenTappedAround()
        
        //Get the keyboard size
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateEventVC.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //Allow uiimage to be zoomable
        //setZoomScale()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //Setup the scrollview for the image
        imageScrollView.delegate = self
        
        imageScrollView.backgroundColor = UIColor.whiteColor()
        
        updateZoom()
        
    }

    override func viewWillLayoutSubviews() {
        
        //Sets zoom right after device orientation change
        //setZoomScale()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //Mark * Tableview Things
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            //tableView.allowsSelection = false
            
        } else if indexPath.section == 1 && indexPath.row == 1 { //Location
            
            performSegueWithIdentifier("createEventToAddLocation", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 2 { //date picker
            
            toggleDatepicker()
        
        } else if indexPath.section == 3 && indexPath.row == 0 {
            
            performSegueWithIdentifier("createEventToEventDetails", sender: self)
            
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
        
        } else {
        
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = UIColor.whiteColor()
        
        header.contentView.backgroundColor = globalColor.inBlue
    
    }
    
    //MARK * Working with the imageview
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        //coordinator.animateAlongsideTransition({ [weak self] _ in self?.updateZoom() },completion: nil)
        
        print("viewWillTransitionToSize Run")
    
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
        print("updateConstraints Run")
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            
            var minZoom = min(imageScrollView.bounds.size.width / image.size.width, imageScrollView.bounds.size.height / image.size.height)
            
            
            print("min zoom \(minZoom)")
            
            if minZoom > 1 {
                
                minZoom = 1
            
                imageScrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            } else if minZoom == lastZoomScale {
                
                minZoom += 0.000001
            
                imageScrollView.zoomScale = minZoom
            
                lastZoomScale = minZoom
            
            }
            
            print("Last Zoom Scale \(lastZoomScale)")
        
        }
        
        print("updateZoom Run")
    
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    override func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
        
        print("scrollViewDidZoom Run")
    }
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        print("viewForZoomingInScrollView")
        
        return imageView
        
    }
    
    /*func setZoomScale() {
        
        let imageViewSize = imageView.bounds.size
        
        let scrollViewSize = imageScrollView.bounds.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        imageScrollView.minimumZoomScale = min(widthScale, heightScale)
        
        imageScrollView.zoomScale = 1.0
    
    }
    
    override func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let imageViewSize = imageView.frame.size
        
        let scrollViewSize = imageScrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    
    }*/
    
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
    
    //Process the image selected to the imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imageView.frame = imageScrollView.frame
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageSet = true
        
        dismissViewControllerAnimated(true, completion: nil)
        
        print("imagePickerControllerDismissed")
    
    }
    
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
    
    //MARK * Navigation
    //Unwind Segue
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
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
        }
    }
    
    //Navigating to invite guests screen
    @IBAction func nextTableButton(sender: AnyObject) {
    
    
    }
    
    @IBAction func nextBarButton(sender: AnyObject) {
    
    
    }
    
}

//TODO Eventually make a slacktext keyboard for the user to use.