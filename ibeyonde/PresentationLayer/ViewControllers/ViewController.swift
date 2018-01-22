//
//  ViewController.swift
//  ibeyonde
//
//  Created by NIKHILESH on 21/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var btnLiveHD: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.designNavigationBar(isBack: false)
        btnLiveHD.layer.cornerRadius = 5
        btnLiveHD.layer.masksToBounds = true
        
        btnHistory.layer.cornerRadius = 5
        btnHistory.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

