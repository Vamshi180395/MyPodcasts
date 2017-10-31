//
//  FavouritesCellController.swift
//  Homework2
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import AVFoundation


protocol OptionButtonsDelegatee{
    func removePodcastFromFavourites(at index:IndexPath)
    func playOrPausePodcatsAccordingly(at index:IndexPath)
}
class FavouritesCellController: UITableViewCell {

    var delegate:OptionButtonsDelegatee!
    var indexPath:IndexPath!
    var media_url: String!

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_author: UILabel!
    @IBOutlet weak var btnremove: UIButton!
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var lbl_feedtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBOutlet weak var playbtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   
    
    @IBAction func playPodcast(_ sender: Any) {
        self.delegate.playOrPausePodcatsAccordingly(at: indexPath);
    }
    
    @IBAction func removeFromFavourites(_ sender: Any) {
         self.delegate?.removePodcastFromFavourites(at: indexPath);
    }
    
}
