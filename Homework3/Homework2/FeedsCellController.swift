//
//  FeedsCellController.swift
//  Homework2
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/21/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import AVFoundation
protocol OptionButtonsDelegate{
    func addPodcastToFavourites(at index:IndexPath)
    func playOrPausePodcatsAccordingly(at index:IndexPath)
}
class FeedsCellController: UITableViewCell {
    var delegate:OptionButtonsDelegate!
    var indexPath:IndexPath!

    @IBOutlet weak var btn_addtofavourites: UIButton!
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var lbl_feedtitle: UILabel!

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var playbtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    @IBAction func playOrPause(_ sender: Any) {
        self.delegate?.playOrPausePodcatsAccordingly(at: indexPath);
    }
    
    @IBAction func addTofavourites(_ sender: Any) {
        self.delegate?.addPodcastToFavourites(at: indexPath);
    }
    
    
}
