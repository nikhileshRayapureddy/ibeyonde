//
//  ViewController.swift
//  ibeyonde
//
//  Created by NIKHILESH on 21/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit
class ViewController: BaseViewController {

    @IBOutlet weak var btnSwitch: UISegmentedControl!
    @IBOutlet weak var clVwList: UICollectionView!
    var arrList = [DeviceListBO]()
    var count = -1
    var isLive = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.designNavigationBar(isBack: false)
        clVwList.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        clVwList.register(UINib(nibName: "LiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveCollectionViewCell")

        app_delegate.showLoader(message: "loading...")
        let layer = ServiceLayer()
        layer.getDeviceList(successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.arrList = response as! [DeviceListBO]
                self.clVwList.reloadData()
                if self.arrList.count > 0
                {
                    let item = self.arrList[0]
                    self.count = 0
                    if iBeyondeUserDefaults.getDefaultMotion() == "latest"
                    {
                        self.isLive = false
                        self.btnSwitch.selectedSegmentIndex = 0
                        self.performSelector(inBackground: #selector(self.getImagesWith(UUID:)), with: item.uuid)
                    }
                    else
                    {
                        self.isLive = true
                        self.btnSwitch.selectedSegmentIndex = 1
                        self.performSelector(inBackground: #selector(self.getLiveImagesWith(UUID:)), with: item.uuid)
                    }
                    
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
            isLive = false
            if self.arrList.count > 0
            {
                for bo in arrList
                {
                    bo.arrImageUrl.removeAll()
                    bo.arrImages.removeAll()
                }
                self.clVwList.reloadData()

                let item = self.arrList[0]
                self.count = 0
                self.getImagesWith(UUID: item.uuid)
            }

        }
        else
        {
            isLive = true
            for bo in arrList
            {
                bo.arrImageUrl.removeAll()
                bo.arrImages.removeAll()
            }
            self.clVwList.reloadData()
            let item = self.arrList[0]
            self.count = 0
            self.getLiveImagesWith(UUID: item.uuid)

        }
    }
    @objc func getLiveImagesWith(UUID :String)
    {
        let layer = ServiceLayer()
        layer.getLiveForList(strID: UUID, successMessage: { (response) in
                let tempBO = listImageBO()
                tempBO.strImage = response as! String
                
                self.arrList[self.count].arrImageUrl = [tempBO]
                if self.count == self.arrList.count - 1
                {
                    DispatchQueue.main.async {
//                        self.clVwList.reloadItems(at: [IndexPath(item: self.count, section: 0)])
                        self.clVwList.reloadData()
                    }

                }
                else
                {
                    DispatchQueue.main.async {
//                        self.clVwList.reloadItems(at: [IndexPath(item: self.count, section: 0)])
                    }
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getLiveImagesWith(UUID: item.uuid)
                }
        }, failureMessage: { (error) in
                if self.count == self.arrList.count - 1
                {
                    DispatchQueue.main.async {
                        self.clVwList.reloadData()
//                        self.clVwList.reloadItems(at: [IndexPath(item: self.count, section: 0)])

                    }
                }
                else
                {
                    DispatchQueue.main.async {
//                        self.clVwList.reloadData()
//                        self.clVwList.reloadItems(at: [IndexPath(item: self.count, section: 0)])

                    }
//                    self.clVwList.reloadData()
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getLiveImagesWith(UUID: item.uuid)
                }
        })
    }

   /* func getLatestImages()
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
            
            let tempBO = response as! listImageBO
            self.arrList[self.count].arrImageUrl = [tempBO]
            if self.count == self.arrList.count - 1
            {

            }
            else
            {
                self.getFirstImage(Index: self.count)
//                self.performSelector(inBackground: #selector(self.getFirstImage(Index:)), with: self.count)
                self.count = self.count + 1
                let item = self.arrList[self.count]
                self.getLatestImageWith(UUID: item.uuid)
            }
        }, failureMessage: { (error) in
            
            if self.count == self.arrList.count - 1
            {
//                app_delegate.removeloder()
//                DispatchQueue.main.async {
//                    self.clVwList.reloadData()
//                }
            }
            else
            {
                self.getFirstImage(Index: self.count)
                self.count = self.count + 1
                let item = self.arrList[self.count]
                self.getImagesWith(UUID: item.uuid)
            }
        })
    }*/

    @objc func getImagesWith(UUID :String)
    {
        let layer = ServiceLayer()
        layer.getImagesForList(strID: UUID, successMessage: { (response) in
                self.arrList[self.count].arrImageUrl = response as! [listImageBO]
                if self.count == self.arrList.count - 1
                {
                    self.getFirstImage(Index: self.count)
                }
                else
                {
                    self.getFirstImage(Index: self.count)
                    self.count = self.count + 1
                    let item = self.arrList[self.count]
                    self.getImagesWith(UUID: item.uuid)
                }
        }, failureMessage: { (error) in
            DispatchQueue.main.async {
                
                if self.count == self.arrList.count - 1
                {
                    self.getFirstImage(Index: self.count)

                }
                else
                {
                    self.getFirstImage(Index: self.count)
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
        if isLive == true
        {
            let width = (ScreenWidth - 30)/2
            let height = (width * 0.95)
            return CGSize (width: width, height: height)
       }
        else
        {
            let width = (ScreenWidth - 30)/2
            let height = (width * 1.215)
            return CGSize (width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if isLive == true
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as! LiveCollectionViewCell
            let listBO = arrList[indexPath.row]
            cell.imgVwLive.image = UIImage()
            if listBO.arrImageUrl.count > 0
            {
                if cell.streamingController != nil
                {
                    cell.streamingController.stop()
                }
                let url = URL(string: listBO.arrImageUrl[0].strImage)!
                
                cell.streamingController = MjpegStreamingController(imageView: cell.imgVwLive)
                cell.streamingController.didStartLoading = { [unowned self] in
                }
                cell.streamingController.didFinishLoading = { [unowned self] in
                    print("finished loading...")
                }
                
//                cell.streamingController.contentURL = url
                cell.streamingController.play(url: url)
                
            }
            cell.btnLiveHD.tag = 1000 + indexPath.row
            cell.lblDeviceName.text = listBO.uuid + " : " + listBO.device_name
            cell.btnLiveHD.addTarget(self, action: #selector(self.btnLiveHDClicked(sender:)), for: .touchUpInside)

            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
            let listBO = arrList[indexPath.row]
            print("index : \(indexPath.row), ImageUrl : \(listBO.arrImageUrl.count),Images : \(listBO.arrImages.count)")
            if listBO.arrImages.count > 0
            {
                cell.imgShot.animationImages = listBO.arrImages
                cell.imgShot.animationDuration = 20
                cell.imgShot.contentMode = .scaleAspectFit
                cell.imgShot.startAnimating()
            }
            cell.lblDeviceName.text = listBO.uuid + " : " + listBO.device_name
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
                let url = URL(string: response as! String)
                if url != nil
                {
                    let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveHDViewController") as! LiveHDViewController
                    vc.URL = url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let alert = UIAlertController(title: "Alert!", message: "Url not found.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
                
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }

        }
    }
    @objc func getFirstImage(Index : Int)
    {
        self.getImageWithIndex(index: Index, currentIndex: 0)
    }
    func getImageWithIndex(index : Int,currentIndex : Int)
    {
        let bo = arrList[index]
        if currentIndex >= bo.arrImageUrl.count
        {
            return
        }
        let URL_IMAGE = URL(string: bo.arrImageUrl[currentIndex].strImage)
        
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        if currentIndex < bo.arrImageUrl.count
                        {
                            if currentIndex + 1 < bo.arrImageUrl.count
                            {
                                self.getImageWithIndex(index: index, currentIndex: currentIndex + 1)
                            }
                            bo.arrImages.append(image!)
                            DispatchQueue.main.async {
                                if self.isLive == false
                                {
                                    self.clVwList.reloadData()
                                }
                            }

                        }
                        else
                        {
                            if index == self.arrList.count - 1
                            {
                                DispatchQueue.main.async {
                                    if self.isLive == false
                                    {
                                        self.clVwList.reloadData()
                                    }
                                }
                            }
                        }
                        
                        //displaying the image
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()

    }
}

