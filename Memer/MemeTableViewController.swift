//
//  MemeTableViewController.swift
//  Memer
//
//  Created by Edward Stamps on 3/23/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource {
    
    var memes = [Meme]()
    
//    lazy var sharedContext = {
//        CoreDataStackManager.sharedInstance().managedObjectContext!
//        }()
//    
    
   override func viewDidLoad() {
   super.viewDidLoad()
    
//    
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
//    memes = appDelegate.memes
    
    
    memes = fetchAllMemes()
    self.showEditor()
    
    
   }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    //this function determines whether to launch on the table or editor page
    
    func fetchAllMemes() -> [Meme] {
        let error: NSErrorPointer = nil
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        
        // Execute the Fetch Request
        let results = sharedContext.executeFetchRequest(fetchRequest, error: error)
        
        // Check for Errors
        if error != nil {
            println("Error in fectchAllMemes(): \(error)")
        }
        
        // Return the results, cast to an array of Person objects
        return results as! [Meme]
    }
    

    func showEditor(){
        if memes.count == 0 {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController")! as! UIViewController
            self.navigationController!.pushViewController(detailController.self, animated: false)
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let memer = memes[indexPath.row]
        let image = UIImage(data: memer.memedImage)
        
        // Set the name and image
        cell.textLabel?.text = memer.topText
        cell.imageView?.image = image
      
        return cell
    }
    
 
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController
     detailController.meme = self.memes[indexPath.row]
      self.navigationController!.pushViewController(detailController, animated: true)
        
   }
    
    @IBAction func newMemeButt(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController")! as! UIViewController
        self.navigationController!.pushViewController(detailController.self, animated: true)
        
       
    }
    
    
 


}