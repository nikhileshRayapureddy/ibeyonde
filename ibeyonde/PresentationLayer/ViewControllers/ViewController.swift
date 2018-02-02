//
//  ViewController.swift
//  ibeyonde
//
//  Created by NIKHILESH on 21/01/18.
//  Copyright © 2018 NIKHILESH. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var clVwList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.designNavigationBar(isBack: false)
        clVwList.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        cell.btnLiveHD.layer.cornerRadius = 5
        cell.btnLiveHD.layer.masksToBounds = true
        
        cell.btnHistory.layer.cornerRadius = 5
        cell.btnHistory.layer.masksToBounds = true

        return cell
    }
}
