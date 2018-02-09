//
//  ViewController.swift
//  ibeyonde
//
//  Created by NIKHILESH on 21/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit
import Kingfisher
class ViewController: BaseViewController {

    @IBOutlet weak var clVwList: UICollectionView!
    var arrList = [DeviceListBO]()
    var count = -1
    var isLatest = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.designNavigationBar(isBack: false)
        clVwList.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        
        app_delegate.showLoader(message: "loading...")
        let layer = ServiceLayer()
        layer.getDeviceList(successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrList = response as! [DeviceListBO]
                if self.arrList.count > 0
                {
                    let item = self.arrList[0]
                    self.count = 0
                    self.getImagesWith(UUID: item.uuid)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let alert = UIAlertController(title: "Alert!", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }

        }

    }
    
    @IBAction func switchClicked(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            if self.arrList.count > 0
            {
                app_delegate.showLoader(message: "Loading....")
                let item = self.arrList[0]
                self.count = 0
                self.getImagesWith(UUID: item.uuid)
            }

        }
        else
        {
            app_delegate.showLoader(message: "Loading....")
            self.getLatestImages()
        }
    }
    func getLatestImages()
    {
        if self.arrList.count > 0
        {
            let item = self.arrList[0]
            self.count = 0
            self.getLatestImageWith(UUID: item.uuid)
        }

    }
    func getLatestImageWith(UUID :String)
    {
        let layer = ServiceLayer()
        layer.getLatestImageForList(strID: UUID, successMessage: { (response) in
            DispatchQueue.main.async {
                let tempBO = response as! listImageBO
                self.arrList[self.count].arrImages = [tempBO]
                if self.count == self.arrList.count - 1
                {
                    app_delegate.removeloder()
                    self.clVwList.reloadData()
                }
                else
                {
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getLatestImageWith(UUID: item.uuid)
                }
            }
        }, failureMessage: { (error) in
            DispatchQueue.main.async {
                
                if self.count == self.arrList.count - 1
                {
                    app_delegate.removeloder()
                    self.clVwList.reloadData()
                }
                else
                {
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getImagesWith(UUID: item.uuid)
                }
            }
        })
    }

    func getImagesWith(UUID :String)
    {
        let layer = ServiceLayer()
        layer.getImagesForList(strID: UUID, successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrList[self.count].arrImages = response as! [listImageBO]
                if self.count == self.arrList.count - 1
                {
                    app_delegate.removeloder()
                    self.clVwList.reloadData()
                }
                else
                {
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getImagesWith(UUID: item.uuid)
                }
            }
        }, failureMessage: { (error) in
            DispatchQueue.main.async {
                
                if self.count == self.arrList.count - 1
                {
                    app_delegate.removeloder()
                    self.clVwList.reloadData()
                }
                else
                {
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getImagesWith(UUID: item.uuid)
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = ScreenWidth - 20
        let height = width * (0.75)
        return CGSize (width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        let listBO = arrList[indexPath.row]

        cell.imgShot.animationImages = self.getImage(bo: listBO)
        cell.imgShot.animationDuration = 20
        cell.imgShot.startAnimating()
        
        cell.btnLiveHD.tag = 1000 + indexPath.row
        cell.btnLiveHD.layer.cornerRadius = 5
        cell.btnLiveHD.layer.masksToBounds = true
        cell.btnLiveHD.addTarget(self, action: #selector(self.btnLiveHDClicked(sender:)), for: .touchUpInside)

        cell.btnHistory.layer.cornerRadius = 5
        cell.btnHistory.layer.masksToBounds = true
        cell.btnHistory.tag = 7000 + indexPath.row
        cell.btnHistory.addTarget(self, action: #selector(self.btnHistoryClicked(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func btnHistoryClicked(sender : UIButton)
    {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        vc.listBO = arrList[sender.tag - 7000]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @objc func btnLiveHDClicked(sender : UIButton)
    {
        app_delegate.showLoader(message: "loading...")
        let layer = ServiceLayer()
        layer.getLiveHDForList(strID: arrList[sender.tag - 1000].uuid, successMessage: { (response) in
            DispatchQueue.main.async {
              app_delegate.removeloder()
                print(response)
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }

        }
    }

    func getImage(bo : DeviceListBO)->[UIImage]
    {
        var arr = [UIImage]()
        for image in bo.arrImages
        {
            
            do {
                let data = try Data(contentsOf: URL(string: image.strImage)!)
                arr.append(UIImage(data: data)!)
            } catch {
                print(error)
            }
        }
        return arr
        
    }
}
