//
//  BaseViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 22/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit
let ScreenWidth =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let app_delegate =  UIApplication.shared.delegate as! AppDelegate

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func designNavigationBar(isBack : Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = .black
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12

        if isBack
        {
            let btnBack = UIButton(type: UIButtonType.custom)
            btnBack.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
            btnBack.setImage(#imageLiteral(resourceName: "back-arrow"), for: UIControlState.normal)
            btnBack.contentHorizontalAlignment = .left
            btnBack.addTarget(self, action: #selector(self.btnBackClicked(sender:)), for: UIControlEvents.touchUpInside)
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
            self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem]
        }
        else
        {
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: UIButton())
            self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem]

        }
        
        let imgLogo = UIImageView(frame: CGRect(x: 0, y: 11  , width: 100 , height: 22))
        imgLogo.backgroundColor = UIColor.clear
        imgLogo.contentMode = .scaleAspectFit
        imgLogo.image = #imageLiteral(resourceName: "LogoNavBar")
        self.navigationItem.titleView = imgLogo
        
    }
    @objc func btnBackClicked(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
