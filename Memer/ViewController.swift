//
//  ViewController.swift
//  Memer
//
//  Created by Edward Stamps on 3/17/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    let picker = UIImagePickerController()
    
    //var memedImage:UIImage!
   
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
   
   
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        picker.delegate = self
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)
        
        
        topText.delegate = self
        bottomText.delegate = self
        
        topText.text = "TOP"
        topText.textAlignment = .Center
        topText.defaultTextAttributes = memeTextAttributes
        
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = .Center
        bottomText.defaultTextAttributes = memeTextAttributes
      
        shareButton.enabled = false
        
        self.cancelEnable()
        
       
       
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSStrokeWidthAttributeName : -2,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
   


    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func pickImage(sender: UIBarButtonItem) {
        
        picker.allowsEditing = true
        
     
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
        
        
     
        
    }
    
    @IBOutlet weak var cancelEnabler: UIBarButtonItem!
    
    @IBAction func shareImage(sender: AnyObject) {
        var doneMeme=generateMemedImage()
       let readyMeme = [doneMeme]
      
        let sharer = UIActivityViewController(activityItems: readyMeme, applicationActivities: nil)
     
        presentViewController(sharer, animated: true, completion: nil)
        sharer.completionWithItemsHandler = activityCompletionHandler
        
            
        
        
        
    }
    
    
    
    func activityCompletionHandler(activity: String!, completion: Bool, returnedItem: [AnyObject]!, activityError: NSError!){
        
        if completion == true {
            save()
            
            dismissViewControllerAnimated(true, completion: nil)
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarViewController")! as UIViewController
       
        self.navigationController!.pushViewController(detailController, animated: true)
            }
        
        else {
            self.toolBar.hidden = false
            self.navBar.hidden = false
            
        }
        
        
    
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:[NSObject : AnyObject]) {
            var chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
           
            imagePickerView.image = chosenImage
            dismissViewControllerAnimated(true, completion: nil)
            shareButton.enabled = true
            
    }
    
    @IBAction func shootPhoto(sender: AnyObject) {
        
        picker.allowsEditing = false
        
        
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
       
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        if textField==topText{
        topText.resignFirstResponder()
        bottomText.becomeFirstResponder()
        }
    else if textField == bottomText {
        bottomText.resignFirstResponder()
        }
        
        return true;
    }
   //by placing the subscribetokeyboard notifications here we have an easy way to ensure the keyboard only moves when the bottom text is being edited 
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        if topText.text == "TOP" {
            topText.text = ""}
        if bottomText.text == "BOTTOM" {
            bottomText.text = ""}
        if textField == bottomText {
            subscribeToKeyboardNotifications()
        }
    }
    
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
  
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        
        self.toolBar.hidden = true
       self.navBar.hidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        
        return memedImage
        
       
    }
    
    func save() {
        //Create the meme
        var memedImage=generateMemedImage()
        var meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image, memedImage: memedImage)
        
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.append(meme)
        
        
   }
    
    func cancelEnable(){
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        
        if appDelegate.memes.count == 0 {
            cancelEnabler.enabled = false
        }
        
        else {
            cancelEnabler.enabled = true
        }
    }
    
   
    

}


