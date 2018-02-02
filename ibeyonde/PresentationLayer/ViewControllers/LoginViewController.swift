//
//  LoginViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 22/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var txtFldUsername: UITextField!
    @IBOutlet weak var txtFldPwd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnLoginClicked(_ sender: UIButton) {
        if txtFldUsername.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid username.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldPwd.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            app_delegate.showLoader(message: "Authenticating...")
            let layer = ServiceLayer()
            layer.loginWithUsername(username: txtFldUsername.text!, password: txtFldPwd.text!, successMessage: { (response) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }, failureMessage: { (error) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    let alert = UIAlertController(title: "Alert!", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }

            })
        }
        

    }
    
    @IBAction func btnRegisterClicked(_ sender: UIButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
