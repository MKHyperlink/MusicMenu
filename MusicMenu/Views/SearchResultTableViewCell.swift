//
//  SearchResultTableViewCell.swift
//  MusicMenu
//
//  Created by Mike on 2018/11/16.
//  Copyright © 2018 Mike. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    
    public static let IDENTIFIER = "searchResultCell"
    
    @IBOutlet weak var imgVwThumb: UIImageView!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(musicInfo: MusicInfo) {
        self.lblTrackName.text = musicInfo.trackName

        if let artisName = musicInfo.artistName, let collectionName = musicInfo.collectionName {
            self.lblSubtitle.text = "\(artisName) - \(collectionName)"
        }
        
        if let thumbnailUrl = musicInfo.artworkUrl100 {
            self.imgVwThumb.sd_setImage(with: URL(string: thumbnailUrl))
        }
    }

}
