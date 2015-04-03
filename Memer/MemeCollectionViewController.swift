//
//  MemeCollectionViewController.swift
//  Memer
//
//  Created by Edward Stamps on 3/23/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource{
    
    var memes: [Meme]!
    
   // @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
    super.viewDidLoad()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    //similar to how we created our table but different commands for collection views

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      //cells are a bit tricker from an image standpoint. We need to set the cell then use an image box in the prototype. Since cells only have backgroundviews as options we need to set it to that
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as UICollectionViewCell
      
        let memer = self.memes[indexPath.row]
      
        cell.backgroundColor = UIColor.whiteColor()
        
        let imageView = UIImageView(image: memer.memedImage)
        cell.backgroundView = imageView
     
        return cell
    }
    
    @IBAction func newMemeButt(sender: AnyObject) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController")! as ViewController
        self.navigationController!.pushViewController(detailController.self, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
  
    
    
}