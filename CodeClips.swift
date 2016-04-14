//
//  CodeClips.swift
//  iN
//
//  Created by Mark Manstof on 4/11/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import Foundation

//UITextView Things
/*
//Declare the delegate in the viewDidLoad
detailsTextView.delegate = self

//Set the dynamic row heigh in hightForRowAtIndexPath
if  indexPath.section == 4 && indexPath.row == 0 {

if detailTextViewHasChanged == false {

return 200

} else {

self.view.layoutIfNeeded()

return UITableViewAutomaticDimension

}

 
//Create action for UITextView and link textView to it
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
 
//Update the table
self.tableView.beginUpdates()
 
self.tableView.endUpdates()
 
// Commit the animation
CATransaction.commit()
 
}
 
 */