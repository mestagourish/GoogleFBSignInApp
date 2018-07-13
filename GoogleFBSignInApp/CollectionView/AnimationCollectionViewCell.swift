//
//  AnimationCollectionViewCell.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 06/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class AnimationCollectionViewCell: UICollectionViewCell {
    //@IBOutlet weak var lblAnimationName: UILabel!
    //@IBOutlet weak var imgAnimation: UIImageView!
    
    @IBOutlet weak var lblAnimationName: UILabel!
    @IBOutlet weak var btnAnimatioName: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAnimatioName.backgroundColor = UIColor.clear
        // Initialization code
        //imgAnimation.isUserInteractionEnabled = true
        //lblAnimationName.isUserInteractionEnabled = true
    }

}
