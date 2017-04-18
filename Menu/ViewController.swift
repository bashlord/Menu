//
//  ViewController.swift
//  Boba
//
//  Created by John Jin Woong Kim on 3/29/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit

class ViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout   {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    // indexes
    // 0 = smoothies
    // 1 = slushes
    // 2 = iced fruit
    // 3 = iced coffee/tea
    // 4 = frappes
    // 5 = hot
    let cellId = "cellId"
    //let titles = ["Smoothies", "Slushies", "Iced Fruit Teas", "Iced Coffees & Teas", "Frappuccinos", "Hot Drinks"]
    let titles = ["Smoothies", "Slushies/Frappes", "Iced Fruit Teas", "Iced Coffees & Teas", "Hot Drinks"]
    var cid: CIDCollectionView!
    var currPage = 0
    
    //var imageDic = [String:Int]()
    //var photos = [Photo]()
    //var indexes = [String:Int]()
    var leftNav_x:CGFloat = 50
    var leftNav_y:CGFloat = 0
    var rightNav_x:CGFloat = 50
    var rightNav_y:CGFloat = 0
    
    var backgroundLabel:UILabel!
    var leftButton: UIButton!
    var rightButton:UIButton!
    
    var navLabel0:UILabel!
    var navLabel1: UILabel!
    // whatever this value is determines what label is in use
    var semaphore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightNav_x = CGFloat(width-50)
        // Do any additional setup after loading the view, typically from a nib.
        //Drink.loadDrinks()
        //Drink.printDrinks()
        loadDrinks()
        //printDrinks()

        //view.backgroundColor = UIColor.beige()
        
        // I  ❤ Boba label
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.attributedText = resizeFont(str: "I ❤ Boba", fontSize: 40)
        //titleLabel.text = "   I  ❤ Boba"
        titleLabel.textColor = UIColor.white
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 25) //.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        //navigationItem.titleView?.layer.borderWidth = 2
        //navigationItem.titleView?.layer.borderColor = UIColor.white.cgColor

        print("navigationItem.titleView frame: ",navigationItem.titleView?.frame )
        
        backgroundLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0 ), size: CGSize(width: width, height: 50) ))
        backgroundLabel.backgroundColor = UIColor.black
        self.view.addSubview(backgroundLabel)
        
        // pager category label title
        navLabel0 = UILabel(frame: CGRect(origin: CGPoint(x: 50, y: 0 ), size: CGSize(width: width-100, height: 50) ))
        navLabel0.backgroundColor = UIColor.defaultColor()
        navLabel0.layer.borderWidth = 2
        navLabel0.layer.borderColor = UIColor.white.cgColor
        navLabel0.textAlignment = .center
        self.view.addSubview(navLabel0)
        
        navLabel1 = UILabel(frame: CGRect(origin: CGPoint(x: 50+navLabel0.frame.size.width, y: 0 ), size: CGSize(width: 0, height: 50) ))
        navLabel1.backgroundColor = UIColor.defaultColor()
        navLabel1.layer.borderWidth = 2
        navLabel1.layer.borderColor = UIColor.white.cgColor
        navLabel1.textAlignment = .center
        navLabel1.attributedText = resizeFont0(str: "", fontSize: 25)
        self.view.addSubview(navLabel1)
        
        leftButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50 ) ) )
        leftButton.addTarget(self, action: #selector(pageLeft), for: .touchUpInside )
        leftButton.imageView?.layer.cornerRadius = 25
        //leftButton.layer.cornerRadius = 20
        leftButton.setImage( UIImage(imageLiteralResourceName: "left" ), for: .normal)
        self.view.addSubview(leftButton)
        
        rightButton = UIButton(frame: CGRect(origin: CGPoint(x: width-50, y: 0 ) , size: CGSize(width: 50, height: 50 ) ) )
        rightButton.addTarget(self, action: #selector(pageRight), for: .touchUpInside )
        rightButton.imageView?.layer.cornerRadius = 25
        //rightButton.layer.cornerRadius = 20
        rightButton.setImage( UIImage(imageLiteralResourceName: "right" ), for: .normal)
        self.view.addSubview(rightButton)
        
        setupCollectionView()
        //navLabel.text = titles[currPage]
        navLabel0.attributedText = resizeFont0(str: titles[currPage], fontSize: 25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageLeft(_ sender: UIButton){
        let cell = collectionView?.cellForItem(at: IndexPath(item:0, section: 0)) as! CIDCollectionView
        let page = (cell.prevPage())
        if page != currPage{
            currPage = page
            //navLabel0.attributedText = resizeFont0(str: titles[currPage], fontSize: 25)
            pageLabel(flag: 0)
            //navLabel.text = titles[currPage]
        }
    }
    
    func pageRight(_ sender: UIButton){
        let cell = collectionView?.cellForItem(at: IndexPath(item:0, section: 0)) as! CIDCollectionView
        let page = (cell.nextPage())
        if page != currPage{
            
            currPage = page
            pageLabel(flag: 1)
            //navLabel.text = titles[currPage]
        }
    }
    
    func pageLabel(flag:Int){
        if flag == 0{//left
            if semaphore == 0{
                navLabel1.frame = CGRect(x: rightNav_x, y: 0, width: 0, height: 50 )
                navLabel1.attributedText = resizeFont0(str: titles[currPage], fontSize: 25)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    //self.navLabel0.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: 0, height: 50)
                    self.navLabel1.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: self.width-100
                        , height: 50)
                    self.navLabel0.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: 0, height: 50)
                }) { (completed: Bool) in}
            semaphore = 1
            }else{
                navLabel0.frame = CGRect(x: rightNav_x, y: 0, width: 0, height: 50 )
                navLabel0.attributedText = resizeFont0(str: titles[currPage], fontSize: 25)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    //self.navLabel1.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: 0, height: 50)
                    self.navLabel0.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: self.width-100
                        , height: 50)
                    self.navLabel1.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: 0, height: 50)
                    }) { (completed: Bool) in}
                semaphore = 0
            }
            
        }else{// right
            if semaphore == 0{
                navLabel1.frame = CGRect(x: 50, y: 0, width: 0, height: 50 )
                navLabel1.attributedText = resizeFont0(str: titles[currPage], fontSize: 25)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.navLabel0.frame = CGRect(x: self.rightNav_x, y: self.leftNav_y, width: 0, height: 50)
                    self.navLabel1.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: self.width-100
                        , height: 50)
                }) { (completed: Bool) in}
            semaphore = 1
            }else{
                navLabel0.frame = CGRect(x: 50, y: 0, width: 0, height: 50 )
                navLabel0.attributedText = resizeFont0(str: titles[currPage], fontSize: 25)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.navLabel1.frame = CGRect(x: self.rightNav_x, y: self.leftNav_y, width: 0, height: 50)
                    self.navLabel0.frame = CGRect(x: self.leftNav_x, y: self.leftNav_y, width: self.width-100
                        , height: 50)
                }) { (completed: Bool) in}
            semaphore = 0
            }
        }
    }
        
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        //collectionView?.frame = CGRect(x: 5, y: 50, width: width-10, height: height-50)
        collectionView?.backgroundColor = UIColor.black
        collectionView?.register(CIDCollectionView.self, forCellWithReuseIdentifier: cellId)
        collectionView?.isPagingEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String = cellId
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CIDCollectionView
        cid = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CIDCollectionView
        cid?.viewController = self
        
        //cid?.prepPhotos()
        //cid?.prepLayouts()
        
        //if cid == nil{
            //cid = cell
        //}
        print("ViewController cid returned")
        return cid!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("sizeForItemAt/width/height ", indexPath, view.frame.width, view.frame.height)
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

}

