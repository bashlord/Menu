//
//  Extensions.swift
//  Boba
//
//  Created by John Jin Woong Kim on 4/1/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//
import UIKit
import Foundation
import CoreData

// priceFlag
// 0 = 2.49
// 1 = 2.99
// 2 = 3.49
// 3 = 3.99

//blendFlag
// 0 = blended
// 1 = iced
// 2 = hot

/*
 if let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist") {
    if let photosFromPlist = NSArray(contentsOf: URL) {
        for dictionary in photosFromPlist {
            let photo = Photo(dictionary: dictionary as! NSDictionary)
            photo.index = i
            photos.append(photo)
            i += 1
        }
    }
 }
 */
var drinkCategories = ["smoothies","slushes", "icedfruit","icedcoffeetea", "frappes","hot"]

var drinkKeys = ["Iced0","Iced1","Hot0", "Hot1", "Hot2", "Hot3","FlavoredMilkTea","Etc", "Traditional", "Frappes", "FruitTea","Slushies", "Smoothies"]
var drinkIndex = [0,1,2,3,4,5,6,7,8,9,10,11,12]

var prices0 = [5,8,9,10,11,12] // 3.99/4.99
var prices1 = [1,6]         // 3.49/4.49
var prices2 = [0,2]            //  2.99/3.89
var prices3 = [3]            // 2.99/3.49
var prices4 = [4]        // 3.49/3.99

// indexes
// 0 = smoothies
// 1 = slushes
// 2 = iced fruit
// 3 = iced coffee/tea
// 4 = frappes
// 5 = hot

var drinks = [[NSManagedObject]]()

func getDrinkPageIndex(name:String)->Int{
    if name == "Smoothies"{
        return 0
    }else if name == "Slushies" || name == "Frappes"{
        return 1
    }else if name == "FruitTea"{
        return 2
    }else if name == "FlavorMilkTea" || (name == "Iced0") || name == "Iced1"{
        return 3
    }/*else if name == "Frappes"{
        return 4
    }*/else if name == "Hot0" || name == "Hot1" || name == "Hot2" || name == "Hot3"{
        return 4
    }else{
        return 5
    }
}

func loadDrinks(){
    for _ in 0...5{
        drinks.append([NSManagedObject]())
    }
    if let URL = Bundle.main.url(forResource: "Drinks", withExtension: "plist") {
        if let drinksFromPlist = NSDictionary(contentsOf: URL) {
            for (k,v) in drinksFromPlist{
                var priceFlag = -1
                //print(k,v)
                let group = String(describing: k)// name of the category drink
                let pageIndex = getDrinkPageIndex(name: group)
                for i in 0...12{
                    if group == drinkKeys[i]{
                        if prices0.contains(i){
                            priceFlag = 0
                        }else if prices1.contains(i){
                            priceFlag = 1
                        }else if prices2.contains(i){
                            priceFlag = 2
                        }else if prices3.contains(i){
                            priceFlag = 3
                        }else if prices4.contains(i){
                            priceFlag = 4
                        }
                        //break after we get the price we need
                        break
                    }
                }
                //save it to drinks
                for n in (v as! NSArray){
                    save(name: n as! String, priceFlag: priceFlag, blendFlag: 0, index: pageIndex)
                }
            }
        }
    }
}

func save(name: String, priceFlag: Int, blendFlag: Int, index:Int) {
    
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
    }
    
    // 1
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    // 2
    let entity =
        NSEntityDescription.entity(forEntityName: "Beverage",
                                   in: managedContext)!
    
    let bev = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
    
    // 3
    bev.setValue(name, forKeyPath: "name")
    bev.setValue( priceForFlag(flag: priceFlag, size: 0) , forKeyPath: "price_small")
    bev.setValue( priceForFlag(flag: priceFlag, size: 1), forKeyPath: "price_medium")
    bev.setValue(blendFlag, forKeyPath: "blended")

    // 4
    do {
        try managedContext.save()
        drinks[index].append(bev)
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

/*
 var prices0 = [5,8,9,10,11,12] // 3.99/4.99
 var prices1 = [1,6]         // 3.49/4.49
 var prices2 = [0,2]            //  2.99/3.89
 var prices3 = [3]            // 2.99/3.49
 var prices4 = [4]        // 3.49/3.99
 */

func priceForFlag(flag: Int, size:Int) -> Double{
    
    if flag == 4{
        if size == 0{
            return 3.49
        }else{
            return 3.99
        }
    }else if flag == 3{
        if size == 0{
            return 2.99
        }else{
            return 3.49
        }
    }else if flag == 1{
        if size == 0{
            return 3.49
        }else{
            return 4.49
        }
    }else if flag == 0{
        if size == 0{
            return 3.99
        }else{
            return 4.99
        }
    }else if flag == 2{
        if size == 0{
            return 2.99
        }else{
            return 3.89
        }
    }
    return -1
}

func printDrinks(){
    print("printDrinks()------")
    var i = 0
    for category in drinks{
        print("category: ", drinkCategories[i], category.count)
        for bev in category{
            print( bev.value(forKey: "name"), bev.value(forKey: "price_medium"), bev.value(forKey: "price_small") )
        }
        i += 1
    }
    print("printDrinks() finished\n\n")
}


extension UIColor {
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func defaultColor() -> UIColor{
        return UIColor.rgb(150, green: 30, blue: 30)
    }
    
    static func beige() -> UIColor{
        return UIColor.rgb(252, green: 239, blue: 225)
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


extension UIImage {
    var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(at: CGPoint.zero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage!
    }
}

func heightForLabel(_ font: UIFont, width: CGFloat, str:String) -> CGFloat {
    let rect = NSString(string: str).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    return ceil(rect.height)
}

func resizeFont(str:String, fontSize: CGFloat) -> NSAttributedString{
    // Returns a NSAttributedString, which is a string with a bunch of attributes that describes something.
    //  In this case, it is describing a font's stroke color, foreground color, font type/size, and stroke width
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: fontSize)!,
        NSStrokeWidthAttributeName : -2.0
        ] as [String : Any]
    // This takes the attributes and combines it with a string that the attributes will be applied to
    let newAttr = NSAttributedString(string: str, attributes: memeTextAttributes)
    return newAttr
}

func resizeFont0(str:String, fontSize: CGFloat) -> NSAttributedString{
    // Returns a NSAttributedString, which is a string with a bunch of attributes that describes something.
    //  In this case, it is describing a font's stroke color, foreground color, font type/size, and stroke width
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: fontSize)!,
        NSStrokeWidthAttributeName : -4.0
        ] as [String : Any]
    // This takes the attributes and combines it with a string that the attributes will be applied to
    let newAttr = NSAttributedString(string: str, attributes: memeTextAttributes)
    return newAttr
}
