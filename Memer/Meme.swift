//
//  Meme.swift
//  Memer
//
//  Created by Edward Stamps on 3/23/15.
//  Copyright (c) 2015 CheckList. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Meme)

class Meme: NSManagedObject {
  
    @NSManaged var topText:String
    
    @NSManaged var memedImage: NSData
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(context: NSManagedObjectContext){
    let entity =  NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!
    super.init(entity: entity, insertIntoManagedObjectContext: context)
        
    }
    
}
    


//struct Meme {
//    let topText:String
//    let bottomText:String
//    let image: UIImage?
//    let memedImage: UIImage
//}




