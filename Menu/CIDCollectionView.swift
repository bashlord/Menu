//
//  CIDCollectionView.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import AVFoundation
import UIKit
import Foundation
import CoreData

class CIDCollectionView: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var flag: Int!
    var layouts = [CIDLayout]()
    // Number of pages.  Required when determining the number of elements per page, as well as
    //  determining the offset for each item
    var numOfPages = 5
    // Index of the current page.  Essential when there are multiple pages for determining the item
    //  for indexPath + offset depending on the page index (see collectionView delegate functions)
    var currPage = 0
    let cellId = "BobaCell"
    
    var imageDic = [String:Int]()
    var photos = [Photo]()
    var indexes = [String:Int]()
    
    var viewController: ViewController? {
        didSet {
            prepPhotos()
            if layouts.count == 0{
                
                for i in 0...numOfPages-1{
                    var l = CIDLayout()
                    l.index = i
                    layouts.append(l)
                }
                for lay in layouts {
                    self.collectionView.collectionViewLayout = lay
                    (self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
                    self.collectionView.reloadData()
                    currPage += 1
                }
                
                
                for i in 0...numOfPages-1{
                    print("CIDCollectionView layout ", layouts[i].index, " has ", layouts[i].getCount(), " params and numofdrinks ", drinks[i].count)
                }
                currPage = 0
                self.collectionView.collectionViewLayout = layouts[currPage]
                self.collectionView.reloadData()
                //(self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        //for i in 0...5{
        //self.layouts.append(CIDLayout())
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CIDLayout())
        //let cv = UICollectionView(frame: .zero, collectionViewLayout: self.layouts[0])
        cv.backgroundColor = UIColor.rgb(224, green: 224, blue: 224)
        //cv.backgroundColor = UIColor.black
        cv.dataSource = self
        cv.delegate = self
        
        //print("A")
        //(cv.collectionViewLayout as! CIDLayout).delegate = self
        //self.layouts[0].delegate = self
        return cv
    }()
    
    func prepPhotos(){
        if photos.count == 0{
            photos = Photo.allPhotos()
            print("allPhotos() called ", photos.count)
            // gets the dic key for the image name and the val is the index
            indexes = Photo.allIndexes()
            print("allIndexes() called ", indexes.count)
            
            mapPhotos()
            print("mapPhotos called")
            //print(imageDic)
            
            //prepPhotos()
            //prepLayouts()
        }
    }
    
    func prepLayouts(){
        print("CIDCollectionView.prepLayouts() called:")
        for i in 0..<numOfPages{
            let l = CIDLayout()
            l.index = i
            self.collectionView.collectionViewLayout = l
            //print("B")
            //l.delegate = self
            self.collectionView.reloadData()
            //print("B1")
            l.delegate = self
            layouts.append(l)
            /*layouts.append(l)
            self.collectionView.collectionViewLayout = layouts[i]
            layouts[i].delegate = self
            //(self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
            self.collectionView.reloadData()*/
            
            print("   layout at page index ", i, " numOfLayouts: ", layouts[i].getCount(), " for currPage: ", currPage, " which has ", drinks[currPage].count," drinks.")
            currPage += 1
        }
        print("CIDCollectionView.prepLayouts() fin\n\n")
        //for lay in layouts {
        //    self.collectionView.collectionViewLayout = lay
        //    (self.collectionView.collectionViewLayout as! CIDLayout).delegate = self
        //    self.collectionView.reloadData()
        //    currPage += 1
       // }
        currPage = 0
        self.collectionView.collectionViewLayout = layouts[currPage]
    }
    

    
    func nextPage() -> Int{
        // Goes to the next page possible
        if currPage < numOfPages-1{
            if currPage == 0{
                self.collectionView.reloadData()
            }
            currPage += 1
            //if layouts[currPage].getCount() == 0{
            //    collectionView.collectionViewLayout = layouts[currPage]
            //    collectionView.reloadData()
            //    (collectionView.collectionViewLayout as! CIDLayout).delegate = self
            //}else{
            //(collectionView.collectionViewLayout as! CIDLayout).delegate = self
            //(layouts[currPage] as! CIDLayout).delegate = self
            //self.collectionView.scroll
            print("curr page: ", currPage, " index: ", layouts[currPage].index)
            print("number of layoutParams: ", layouts[currPage].getCount())
            print("number of drinks for category: ", drinks[currPage].count, "\n")
            
            //self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0 ), at: ., animated: true)
            
            self.collectionView.collectionViewLayout = layouts[currPage]
            self.collectionView.reloadSections(  NSIndexSet(index: 0) as IndexSet )
            //self.collectionView.reloadData()
            //}
        }
        return currPage
    }
    
    func prevPage() -> Int{
        // Goes to the previous page possible
        if currPage > 0{
            if currPage == numOfPages-1{
                self.collectionView.reloadData()
            }
            
            currPage -= 1
            //if layouts[currPage].getCount() == 0{
            //    collectionView.collectionViewLayout = layouts[currPage]
             //   collectionView.reloadData()
            //    (collectionView.collectionViewLayout as! CIDLayout).delegate = self
            //}else{
            //(layouts[currPage] as! CIDLayout).delegate = self
            print("curr page: ", currPage, " index: ", layouts[currPage].index)
            print("number of layoutParams: ", layouts[currPage].getCount())
            print("number of drinks for category: ", drinks[currPage].count, "\n")
            //self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0 ), at: .top, animated: true)
            
            self.collectionView.collectionViewLayout = layouts[currPage]
            self.collectionView.reloadSections(  NSIndexSet(index: 0) as IndexSet )
            //self.collectionView.reloadData()
            //let indexSet = NSIndexSet(index: 0)
            
            //}
        }
        return currPage
    }
    
    override func setupViews() {
        super.setupViews()
        print("CIDCollectionView initialized.")
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|-50-[v0]|", views: collectionView)
        
        collectionView.register(BobaCell.self, forCellWithReuseIdentifier: cellId)
        
        //prepPhotos()
        //prepLayouts()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewController == nil{
            return 0
        }
        return drinks[currPage].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BobaCell", for: indexPath) as! BobaCell
        let rounded = Int(ceil(Double(photos.count/numOfPages)))
        let drink = (drinks[currPage] )[indexPath.item]
        let name = drink.value(forKey: "name") as! String
        let smallPrice = String(drink.value(forKey: "price_small") as! Double)
        let medPrice = String(drink.value(forKey: "price_medium") as! Double)
        let label = name //+ ": $" + smallPrice + "/$" + medPrice
        cell.labelStr = label
        cell.priceStr = "$" + smallPrice + "/$" + medPrice
        cell.photo = photos[ imageDic[(drink.value(forKey: "name") as! String)]! ]
        return cell
    }
    
    
    func mapPhotos(){
        var i = 0
        if let URL = Bundle.main.url(forResource: "DrinkImages", withExtension: "plist") {
            if let photosFromPlist = NSDictionary(contentsOf: URL) {
                for (k,v) in photosFromPlist {
                    //let key = k as! String
                    //let val = v as! [String]
                    //print("key: ",k,"value: ",v)
                    for drink in (v as! NSArray){
                        // key = name of drink
                        // value = index of the drink's UIImage
                        //print((drink as! String), " key set to ", indexes[k as! String])
                        imageDic[drink as! String] = indexes[k as! String]
                        // to get the index value, plug in the category name as the key
                        
                    }
                    i += 1
                    //let photo = Photo(dictionary: dictionary as! NSDictionary)
                    //photos.append(photo)
                    
                }
            }
        }
    }
    
}

extension CIDCollectionView : CIDLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        //let rounded = Int(ceil(Double(photos.count/numOfPages)))
        //let photo = photos[(rounded*currPage)+indexPath.item]
        let drink = (drinks[currPage] )[indexPath.item]
        //print("drink: ", (drink.value(forKey: "name") as! String), imageDic.count)
        //print(imageDic)
        let photo = photos[ imageDic[(drink.value(forKey: "name") as! String)]! ]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect)
        //print("CIDCollectionView A", (collectionView.collectionViewLayout as! CIDLayout).getCount() )
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        
        let drink = (drinks[currPage] )[indexPath.item]
        let name = drink.value(forKey: "name") as! String
        let smallPrice = String(drink.value(forKey: "price_small") as! Double)
        let medPrice = String(drink.value(forKey: "price_medium") as! Double)
        let labelStr = name + ": $" + smallPrice + "/$" + medPrice
        
        //let photo = photos[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = heightForLabel(font, width: width, str: labelStr)  // (font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        //print("CIDCollectionView B", (collectionView.collectionViewLayout as! CIDLayout).getCount() )
        return height
    }
}
