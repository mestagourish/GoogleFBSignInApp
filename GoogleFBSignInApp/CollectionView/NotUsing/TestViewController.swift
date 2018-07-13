//
//  TestViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 06/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var strCellIdentifier : String = "SongsCell"
    @IBAction func btnSongs(_ sender: UIButton) {
        strCellIdentifier = "SongsCell"
        TestCollectionView.reloadData()
    }
    @IBAction func btnAnimation(_ sender: UIButton) {
        strCellIdentifier = "AnimationCell"
        TestCollectionView.reloadData()
    }
    @IBAction func btnMessage(_ sender: Any) {
        strCellIdentifier = "MessageCell"
        TestCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returningCell : UICollectionViewCell!
        if strCellIdentifier == "SongsCell"
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(self.strCellIdentifier)", for: indexPath) as! SongsCollectionViewCell
            cell.lblSongsName.text = "Sanata Song"
            returningCell = cell
        }
        else if strCellIdentifier == "AnimationCell"
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(self.strCellIdentifier)", for: indexPath) as! AnimationCollectionViewCell
            //cell.lblAnimationName.text = "Animation Data"
            returningCell = cell
        }
        else if strCellIdentifier == "MessageCell"
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(self.strCellIdentifier)", for: indexPath) as! MessageCollectionViewCell
            cell.lblMesage.text = "Message Data"
            returningCell = cell
        }
        return returningCell
    }
    
    @IBOutlet weak var TestCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TestCollectionView.delegate = self
        TestCollectionView.dataSource = self
        TestCollectionView.register(UINib(nibName:"SongsCollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "SongsCell")
        TestCollectionView.register(UINib(nibName:"AnimationCollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "AnimationCell")
        TestCollectionView.register(UINib(nibName:"MessageCollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "MessageCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 405.0, height: 50.0)
    }
    //defines the spaces between the images
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 30, 30, 30)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
