//
//  TabDataViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 09/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class TabDataViewController: UIViewController {
    @IBOutlet weak var lblSongCellData: UILabel!
    @IBOutlet weak var lblAnimationCellData: UILabel!
    @IBOutlet weak var lblMessageCellData: UILabel!
    
    var strSongCellData: String!
    var strAnimationCellData: String!
    var strMessageCellData: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMessageCellData.text = strMessageCellData!
        lblAnimationCellData.text = strAnimationCellData!
        lblSongCellData.text = strSongCellData!
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
