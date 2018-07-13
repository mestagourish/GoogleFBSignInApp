//
//  SongsCollectionViewCell.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 06/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class SongsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnPlaySong: UIButton!
    @IBOutlet weak var lblSongsName: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
