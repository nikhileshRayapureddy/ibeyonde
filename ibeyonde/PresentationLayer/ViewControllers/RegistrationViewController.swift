//
//  RegistrationViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 22/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController {

    @IBOutlet weak var txtFldUsername: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPhoneNo: UITextField!
    @IBOutlet weak var txtFldPwd: UITextField!
    @IBOutlet weak var txtFldReEnterPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.designNavigationBar(isBack: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegisterClicked(_ sender: UIButton) {
        if txtFldUsername.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid username.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldEmail.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Email.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldPhoneNo.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Phone Number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldPwd.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldReEnterPwd.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Re-enter Password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtFldEmail.text!.isValidEmail() == false
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid Email ID.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        else if txtFldReEnterPwd.text != txtFldPwd.text
        {
            let alert = UIAlertController(title: "Alert!", message: "Password and Re-enter Paswword doesn't match.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else
        {
            app_delegate.showLoader(message: "Registering....")
            let layer = ServiceLayer()
            layer.registerWithUsername(username: txtFldUsername.text!, email: txtFldEmail.text!, password: txtFldPwd.text!, phone: txtFldPhoneNo.text!, successMessage: { (reponse) in
                DispatchQueue.main.async {
                    app_delegate.removeloder()
                    let alert = UIAlertController(title: "Alert!", message: "Registration successful.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        DispatchQueue.main.async {
                            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)

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
}
extension String
{
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self) && self.count > 1;
    }

}
