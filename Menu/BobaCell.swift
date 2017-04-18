//
//  AnnotatedPhotoCell.swift
//  Rendezvous2
//
//  Created by John Jin Woong Kim on 2/12/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import UIKit

class BobaCell: BaseCell {
    //var name:String!
    //var prices: String!
    var labelStr: String!
    var priceStr: String!
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                setupViews()
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var imageViewHeightLayoutConstraint: NSLayoutConstraint?
    var imageViewWidthLayoutConstraint: NSLayoutConstraint?
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? CIDLayoutAttributes {
            imageViewHeightLayoutConstraint?.constant = attributes.photoHeight
        }
    }
    
    override func setupViews() {
        super.setupViews()
        if photo != nil{
            imageView.image = photo?.image
            addSubview(imageView)
            
            captionLabel.attributedText = resizeFont0(str: labelStr, fontSize: 35)
            addSubview(captionLabel)
            
            priceLabel.attributedText = resizeFont0(str: priceStr, fontSize: 25)
            addSubview(priceLabel)
            
            //imageViewHeightLayoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0)
            //addConstraint(imageViewHeightLayoutConstraint!)
            //imageViewWidthLayoutConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
            //addConstraint(imageViewWidthLayoutConstraint!)
            
            addConstraintsWithFormat("H:|[v0]|", views: imageView)
            addConstraintsWithFormat("V:|[v0]|", views: imageView)
            
            addConstraintsWithFormat("H:|[v0]|", views: captionLabel)
            addConstraintsWithFormat("V:|[v0]", views: captionLabel)
            
            addConstraintsWithFormat("H:[v0]|", views: priceLabel)
            addConstraintsWithFormat("V:[v0]|", views: priceLabel)
            
        }
    }
}
