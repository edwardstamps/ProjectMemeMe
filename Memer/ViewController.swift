//
//  ViewController.swift
//  Memer
//
//  Created by Edward Stamps on 3/17/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "08f89a20636b58be8c6b7b2c3bd4555c"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"
let StaticMeme = ["cute animal", "puppy", "holiday fail", "kitten","fail", "Game of Thrones"]

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
        topText.hidden = true
        
        topText.text = "TOP"
        topText.textAlignment = .Center
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.hidden = true
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
            topText.hidden = false
            bottomText.hidden = false
            
            
    }
    
    @IBAction func shootPhoto(sender: AnyObject) {
        
        picker.allowsEditing = false
        
        
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
        
       }
    
    
    @IBAction func pickFlick(sender: AnyObject) {
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": StaticMeme[Int(arc4random_uniform(UInt32(StaticMeme.count)))],
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        /* 2 - Call the Flickr API with these arguments */
        getImageFromFlickrBySearch(methodArguments)
        topText.hidden = false
        bottomText.hidden = false
        shareButton.enabled = true
        
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
        
        
        //flickerfunctions
        
    }
        
        func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
            
            let session = NSURLSession.sharedSession()
            let urlString = BASE_URL + escapedParameters(methodArguments)
            let url = NSURL(string: urlString)!
            let request = NSURLRequest(URL: url)
            
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if let error = downloadError? {
                    println("Could not complete the request \(error)")
                } else {
                    var parsingError: NSError? = nil
                    let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as NSDictionary
                    
                    if let photosDictionary = parsedResult.valueForKey("photos") as? [String:AnyObject] {
                        
                        var totalPhotosVal = 0
                        if let totalPhotos = photosDictionary["total"] as? String {
                            totalPhotosVal = (totalPhotos as NSString).integerValue
                        }
                        
                        if totalPhotosVal > 0 {
                            if let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] {
                                
                                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
                                let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
                                
                                let photoTitle = photoDictionary["title"] as? String
                                let imageUrlString = photoDictionary["url_m"] as? String
                                let imageURL = NSURL(string: imageUrlString!)
                                
                                if let imageData = NSData(contentsOfURL: imageURL!) {
                                    dispatch_async(dispatch_get_main_queue(), {
                                      //  self.defaultLabel.alpha = 0.0
                                        self.imagePickerView.image = UIImage(data: imageData)
                                        
                                      //  self.photoTitleLabel.text = "\(photoTitle!)"
                                    })
                                } else {
                                    println("Image does not exist at \(imageURL)")
                                }
                            } else {
                                println("Cant find key 'photo' in \(photosDictionary)")
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                               // self.photoTitleLabel.text = "No Photos Found. Search Again."
                             //   self.defaultLabel.alpha = 1.0
                                self.imagePickerView.image = nil
                            })
                        }
                    } else {
                        println("Cant find key 'photos' in \(parsedResult)")
                    }
                }
            }
            
            task.resume()
        }
        
        /* Helper function: Given a dictionary of parameters, convert to a string for a url */
        func escapedParameters(parameters: [String : AnyObject]) -> String {
            
            var urlVars = [String]()
            
            for (key, value) in parameters {
                
                /* Make sure that it is a string value */
                let stringValue = "\(value)"
                
                /* Escape it */
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                /* FIX: Replace spaces with '+' */
                let replaceSpaceValue = stringValue.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                /* Append it */
                urlVars += [key + "=" + "\(replaceSpaceValue)"]
            }
            
            return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
        }

}


