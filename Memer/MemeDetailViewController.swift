//
//  MemeDetailViewController.swift
//  Memer
//
//  Created by Edward Stamps on 3/31/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    var meme : Meme!
    
    @IBOutlet weak var memePic: UIImageView!
    
    
    override func viewDidLoad() {
        self.memePic!.image = meme.memedImage
    }
    
    
   
    @IBAction func returnPage(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
   
    
}
