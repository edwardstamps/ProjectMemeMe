//
//  MemeTableViewController.swift
//  Memer
//
//  Created by Edward Stamps on 3/23/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource {
    
    var memes: [Meme]!
    
 
    
    
   override func viewDidLoad() {
   super.viewDidLoad()
    
    
  let object = UIApplication.sharedApplication().delegate
  let appDelegate = object as AppDelegate
    memes = appDelegate.memes
  self.showEditor()
    
    
   }
    
    func showEditor(){
        if memes.count == 0 {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController")! as UIViewController
            self.navigationController!.pushViewController(detailController.self, animated: false)
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let memer = self.memes[indexPath.row]
        
        // Set the name and image
       cell.textLabel?.text = memer.topText
        cell.imageView?.image = memer.memedImage
      
        return cell
    }
    
 
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
     detailController.meme = self.memes[indexPath.row]
      self.navigationController!.pushViewController(detailController, animated: true)
        
   }
    
    @IBAction func newMemeButt(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController")! as UIViewController
        self.navigationController!.pushViewController(detailController.self, animated: true)
        
       
    }
    
    
 


}