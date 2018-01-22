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

    @IBOutlet weak var btnPlayer: UIButton!
    @IBOutlet weak var vwListingBg: UIView!
    @IBOutlet weak var vwPlayerBg: UIView!
    @IBOutlet weak var vwCalendar: FSCalendar!
    @IBOutlet weak var clVwHistory: UICollectionView!
    @IBOutlet weak var vwPickerBase: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var constVwPickerBaseBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lblListing: UILabel!
    @IBOutlet weak var lblPlayer: UILabel!
    @IBOutlet weak var btnSelListing: UIButton!
    @IBOutlet weak var btnSelPlayer: UIButton!
    var selectedPickerRow = 0
    var isPlayerSelected = false
    var arrList = [String]()
    var arrImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBar(isBack: true)
        // Do any additional setup after loading the view.
        arrList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
        vwListingBg.layer.cornerRadius = 5
        vwListingBg.layer.masksToBounds = true
        vwListingBg.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        vwListingBg.layer.borderWidth = 1
        
        
        vwPlayerBg.layer.cornerRadius = 5
        vwPlayerBg.layer.masksToBounds = true
        vwPlayerBg.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        vwPlayerBg.layer.borderWidth = 1

        btnPlayer.layer.cornerRadius = 5
        btnPlayer.layer.masksToBounds = true

        vwCalendar.scope = .week
        vwCalendar.adjustMonthPosition()
        vwCalendar.select(Date(), scrollToDate: true)
        clVwHistory.register(UINib(nibName: "HistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        constVwPickerBaseBottom.constant = 200

    }

    @IBAction func btnDoneClicked(_ sender: UIButton) {
        constVwPickerBaseBottom.constant = 200
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        if isPlayerSelected
        {
            lblPlayer.text = "Player " + arrList[selectedPickerRow]
        }
        else
        {
            lblListing.text = "List " + arrList[selectedPickerRow]
        }
    }
    
    @IBAction func btnPlayerClicked(_ sender: UIButton) {
        constVwPickerBaseBottom.constant = 0
        isPlayerSelected = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnListingClicked(_ sender: UIButton) {
        constVwPickerBaseBottom.constant = 0
        isPlayerSelected = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50//arrImages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = ScreenWidth - 20
        let height = width * (0.75)
        return CGSize (width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        cell.imgVw.image = #imageLiteral(resourceName: "SampleImage")
        return cell
    }
}
extension HistoryViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPickerRow = row
    }
}
