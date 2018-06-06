//
//  SideMenuViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 10/02/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit
import AKSideMenu

class SideMenuViewController: UIViewController {
    @IBOutlet weak var tblViewMenu: UITableView!
    var arrTitles = [String]()
    var navController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        arrTitles = ["Home","Settings", "Logout"]

        // Do any additional setup after loading the view.
    }
    func logOutUser()
    {
        DispatchQueue.main.async {
            iBeyondeUserDefaults.setLoginStatus(object: "false")
            iBeyondeUserDefaults.setDefaultMotion(object: "latest")
            let navigationController: UINavigationController = UINavigationController.init(rootViewController: UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController"))
            
            app_delegate.window!.rootViewController = navigationController
            app_delegate.window!.backgroundColor = UIColor.white
            app_delegate.window?.makeKeyAndVisible()
        }
    }
    func goToHome()
    {
        DispatchQueue.main.async {
            let viewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navController = UINavigationController(rootViewController: viewController)
            self.sideMenuViewController!.setContentViewController(self.navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.lblTitle.text = arrTitles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = arrTitles[indexPath.row]
        
        if selectedItem == "Home"
        {
            self.goToHome()
        }
        else if selectedItem == "Settings"
        {
            let liveViewController = UIStoryboard (name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            navController = UINavigationController(rootViewController: liveViewController)
            self.sideMenuViewController!.setContentViewController(navController!, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
        }
        else // "Logout"
        {
            let alert = UIAlertController(title: "Alert!", message: "Are you sure, you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (completed) in
                self.goToHome()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (completed) in
                self.logOutUser()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SideMenuViewController : AKSideMenuDelegate
{
    open func sideMenu(_ sideMenu: AKSideMenu, shouldRecognizeGesture recognizer: UIGestureRecognizer, simultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return true to allow both gesture recognizers to recognize simultaneously. Returns false by default
        return false
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return true or false based on your failure requirements. Returns false by default
        return false
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return true or false based on your failure requirements. Returns false by default
        return false
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    open func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
    
}
