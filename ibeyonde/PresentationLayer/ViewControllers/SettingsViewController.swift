//
//  SettingsViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 16/02/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var btnLatestMotion: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.designNavigationBar(isBack: false)
    }

    @IBAction func btnLatestMotionClicked(_ sender: UIButton) {
        btnLive.isSelected = false
        sender.isSelected = true
        iBeyondeUserDefaults.setDefaultMotion(object: "latest")
    }
    @IBAction func btnLiveClicked(_ sender: UIButton) {
        btnLatestMotion.isSelected = false
        sender.isSelected = true
        iBeyondeUserDefaults.setDefaultMotion(object: "live")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
