//
//  MesseageCollectionViewCell.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 06/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblMesage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMesage.sizeToFit()
    }

}
