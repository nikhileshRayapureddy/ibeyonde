//
//  RootViewController.swift
//  GetION
//
//  Created by Medico Desk on 11/10/17.
//  Copyright © 2017 Medico Desk. All rights reserved.
//

import UIKit
import AKSideMenu

class RootViewController: AKSideMenu {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override public func awakeFromNib() {
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController")
        self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
