//
//  LiveHDViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 10/02/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class LiveHDViewController: BaseViewController {

    @IBOutlet weak var imgVwLiveHD: UIImageView!
    
    @IBOutlet weak var constImgLiveHDHeight: NSLayoutConstraint!
    var streamingController: MjpegStreamingController!
    var loader = UIActivityIndicatorView()
    var URL : URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar(isBack: true)
        if URL != nil
        {
            loader.activityIndicatorViewStyle = .gray
            loader.hidesWhenStopped = true
            loader.center = imgVwLiveHD.center
            imgVwLiveHD.addSubview(loader)
            
            // Do any additional setup after loading the view.
            streamingController = MjpegStreamingController(imageView: imgVwLiveHD)
            streamingController.didStartLoading = { [unowned self] in
                self.loader.startAnimating()
            }
            streamingController.didFinishLoading = { [unowned self] in
                self.loader.stopAnimating()
            }
            
            streamingController.contentURL = URL
            streamingController.play()
        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "Url not found.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
