//
//  HistoryViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 22/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit
import FSCalendar
import Kingfisher
class HistoryViewController: BaseViewController {

    @IBOutlet weak var lblSliderVal: UILabel!
    @IBOutlet weak var vwCalendar: FSCalendar!
    @IBOutlet weak var clVwHistory: UICollectionView!
    @IBOutlet weak var imgVwHistory: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    var selectedindex = 1
    var listBO = DeviceListBO()
    var arrList = [listImageBO]()
    var arrImages = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar(isBack: true)
        // Do any additional setup after loading the view.

        vwCalendar.scope = .week
        vwCalendar.adjustMonthPosition()
        vwCalendar.select(Date(), scrollToDate: true)
        clVwHistory.register(UINib(nibName: "HistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        self.getHistory()
        lblSliderVal.text = "\(selectedindex)"

    }
    func getHistory()
    {
        app_delegate.showLoader(message: "Loading....")
        let date = vwCalendar.selectedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let strDate = formatter.string(from: date!)
        let layer = ServiceLayer()
        layer.getHistoryWith(strID: listBO.uuid,strDate: strDate,strTime: "\(selectedindex)", successMessage: { (response) in
                self.arrList = response as! [listImageBO]
                if self.arrList.count > 0
                {
                    app_delegate.removeloder()
                    self.getFirstImage(Index: 0)
                }
                else
                {
                    if self.selectedindex < 23
                    {
                        self.selectedindex = self.selectedindex + 1
                        self.getHistory()
                    }
                    else
                    {
                        app_delegate.removeloder()
                    }

                }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
            
        }

    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        lblSliderVal.text = "\(Int(round(sender.value)))"
    }
    
    @IBAction func btnGoClicked(_ sender: UIButton) {
        selectedindex = Int(lblSliderVal.text!)!
        self.getHistory()

    }
    func getImage(arrList : [listImageBO])->[UIImage]
    {
        var arr = [UIImage]()
        for image in arrList
        {
            let url = URL(string: image.strImage)
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    let data = try Data(contentsOf: URL(string: image.strImage)!)
                    arr.append(UIImage(data: data)!)
                } catch {
                    print(error)
                }
            }
        }
        return arr
        
    }
    @objc func getFirstImage(Index : Int)
    {
        self.getImageWithIndex(index: Index, currentIndex: 0)
    }
    func getImageWithIndex(index : Int,currentIndex : Int)
    {
        if currentIndex >= arrList.count
        {
            return
        }
        let URL_IMAGE = URL(string: arrList[currentIndex].strImage)
        
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
                        if currentIndex < self.arrList.count
                        {
                            if currentIndex + 1 < self.arrList.count
                            {
                                self.getImageWithIndex(index: index, currentIndex: currentIndex + 1)
                            }
                            self.arrImages.append(image!)
                            DispatchQueue.main.async {
                                self.imgVwHistory.animationImages = self.arrImages
                                self.imgVwHistory.animationDuration = 20
                                self.imgVwHistory.contentMode = .scaleAspectFit
                                self.imgVwHistory.startAnimating()
                            }
                            
                        }
                        else
                        {
                            if index == self.arrList.count - 1
                            {
                                DispatchQueue.main.async {
                                    self.imgVwHistory.animationImages = self.arrImages
                                    self.imgVwHistory.animationDuration = 20
                                    self.imgVwHistory.contentMode = .scaleAspectFit
                                    self.imgVwHistory.startAnimating()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 23//arrImages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = ScreenWidth/10
        return CGSize (width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        cell.lblTime.text = "\(indexPath.item + 1)"
        cell.lblTime.layer.cornerRadius = ScreenWidth/20
        cell.lblTime.layer.masksToBounds = true
        cell.lblTime.layer.borderColor = UIColor.blue.cgColor
        cell.lblTime.layer.borderWidth = 2
        if selectedindex == indexPath.row
        {
            cell.lblTime.backgroundColor = UIColor.blue
            cell.lblTime.textColor = UIColor.white
        }
        else
        {
            cell.lblTime.backgroundColor = UIColor.clear
            cell.lblTime.textColor = UIColor.blue
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedindex = indexPath.item
        collectionView.reloadData()
        self.getHistory()

    }
}

