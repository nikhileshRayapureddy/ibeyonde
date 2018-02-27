//
//  LiveViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 10/02/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class LiveViewController: BaseViewController {
    
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
        clVwList.register(UINib(nibName: "LiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveCollectionViewCell")
        
        app_delegate.showLoader(message: "loading...")
        let layer = ServiceLayer()
        layer.getDeviceList(successMessage: { (response) in
            DispatchQueue.main.async {
                self.arrList = response as! [DeviceListBO]
                if self.arrList.count > 0
                {
                    let item = self.arrList[0]
                    self.count = 0
                    self.getLiveImagesWith(UUID: item.uuid)
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
    
 
    func getLiveImagesWith(UUID :String)
    {
        let layer = ServiceLayer()
        layer.getLiveForList(strID: UUID, successMessage: { (response) in
            DispatchQueue.main.async {
                let tempBO = listImageBO()
                tempBO.strImage = response as! String
                
                self.arrList[self.count].arrImageUrl = [tempBO]
                if self.count == self.arrList.count - 1
                {
                    app_delegate.removeloder()
                    self.clVwList.reloadData()
                }
                else
                {
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getLiveImagesWith(UUID: item.uuid)
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
                    self.getLiveImagesWith(UUID: item.uuid)
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension LiveViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as! LiveCollectionViewCell
        let listBO = arrList[indexPath.row]

        if listBO.arrImages.count > 0
        {
                let url = URL(string: listBO.arrImageUrl[0].strImage)!
            
                cell.streamingController = MjpegStreamingController(imageView: cell.imgVwLive)
                cell.streamingController.didStartLoading = { [unowned self] in
                }
                cell.streamingController.didFinishLoading = { [unowned self] in
                }
                
                cell.streamingController.contentURL = url
                cell.streamingController.play()
            
        }
        return cell
    }
}
