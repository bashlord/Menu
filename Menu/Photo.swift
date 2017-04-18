//
//  Photo.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit
import CoreFoundation

var urls = ["almond","kiwi","peanutbutter","americano","lemonade","pineapple","banana","lychee","pistachio","blacktea","mango","raspberry","cafelatte","matcha","redbean","cafemocha","melon","strawberry","caramel","milktea","taro","caramelmacchiato","mintchocolatechip","thaitea","chai","mixedgrain","vanilla","coconut","mocha","watermelon","coffee","oreo","whitecafemocha","greenapple","passionfruit", "yogurt", "peach","greentea","cap","coco", "seng","ginger", "juju","jobs", "citron", "hazel"]

class Photo {
    
    
    class func allPhotos() -> [Photo] {
        var photos = [Photo]()
        /*if let URL = Bundle.main.url(forResource: "DrinkImages", withExtension: "plist") {
            if let photosFromPlist = NSDictionary(contentsOf: URL) {
                for (k,v) in photosFromPlist {
                    
                    //let photo = Photo(dictionary: dictionary as! NSDictionary)
                    //photos.append(photo)
                }
            }
        }*/
        for photoUrl in urls{
            let photo = Photo(image: UIImage(imageLiteralResourceName: photoUrl), name:photoUrl )// UIImage(imageLiteralResourceName: photoUrl)
            photos.append(photo)
        }
        return photos
    }
    
    class func allIndexes() -> [String:Int]{
        print("allIndexes() start")
        var ret = [String: Int]()
        var i = 0
        for name in urls{
            //print("name ", name, " set to index ", i)
            ret[name] = i
            i += 1
        }
        print("allIndexes() end")

        return ret
    }
    
    var image: UIImage
    var name:String
    
    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
    
    /*convenience init(dictionary: NSDictionary) {
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(image: image!)
    }*/
    
    func heightForComment(_ font: UIFont, width: CGFloat, str:String) -> CGFloat {
        let rect = NSString(string: str).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
