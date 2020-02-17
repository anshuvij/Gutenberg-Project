//
//  CollectionViewCell.swift
//  Gutenberg Project
//
//  Created by Anshu Vij on 2/14/20.
//  Copyright © 2020 Anshu Vij. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
         imageView.layer.masksToBounds = true
    }

}
