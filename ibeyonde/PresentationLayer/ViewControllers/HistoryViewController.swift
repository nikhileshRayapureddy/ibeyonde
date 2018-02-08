//
//  HistoryViewController.swift
//  ibeyonde
//
//  Created by Nikhilesh on 22/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit
import FSCalendar

class HistoryViewController: BaseViewController {

    @IBOutlet weak var vwCalendar: FSCalendar!
    @IBOutlet weak var clVwHistory: UICollectionView!
    @IBOutlet weak var imgVwHistory: UIImageView!
    
    var selectedindex = 0
    var listBO = DeviceListBO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar(isBack: true)
        // Do any additional setup after loading the view.

        vwCalendar.scope = .week
        vwCalendar.adjustMonthPosition()
        vwCalendar.select(Date(), scrollToDate: true)
        clVwHistory.register(UINib(nibName: "HistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        self.getHistory()
    }
    func getHistory()
    {
        app_delegate.showLoader(message: "Loading....")
        let layer = ServiceLayer()
        layer.getHistoryWith(strID: listBO.uuid,strDate: "2018/02/08",strTime: "\(selectedindex + 1)", successMessage: { (response) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                let arrList = response as! [listImageBO]
                if arrList.count > 0
                {
                    self.imgVwHistory.animationImages = self.getImage(arrList: arrList)
                    self.imgVwHistory.animationDuration = 50
                    self.imgVwHistory.startAnimating()
                }
                else
                {
                    self.clVwHistory.selectItem(at: IndexPath(item: self.selectedindex + 1, section: 0), animated: true, scrollPosition: .top)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
            }
            
        }

    }
    func getImage(arrList : [listImageBO])->[UIImage]
    {
        var arr = [UIImage]()
        for image in arrList
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

