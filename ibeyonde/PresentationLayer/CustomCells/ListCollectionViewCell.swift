//
//  ListCollectionViewCell.swift
//  ibeyonde
//
//  Created by Nikhilesh on 30/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var btnLiveHD: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var imgShot: UIImageView!
    var streamingController: MjpegStreamingController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override open var isSelected: Bool
        {
        set {
            
        }
        
        get {
            return super.isSelected
        }
    }
    
    override open var isHighlighted: Bool
        {
        set {
            
        }
        
        get {
            return super.isHighlighted
        }
    }

}
