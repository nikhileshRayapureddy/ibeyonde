//
//  LiveCollectionViewCell.swift
//  ibeyonde
//
//  Created by Nikhilesh on 10/02/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class LiveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var btnLiveHD: UIButton!
    @IBOutlet weak var imgVwLive: UIImageView!
    var streamingController: MjpegStreamingController!

}
