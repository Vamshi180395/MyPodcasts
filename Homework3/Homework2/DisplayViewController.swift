//
//  DisplayViewController.swift
//  Homework2
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import AVFoundation

class DisplayViewController: UIViewController {
    var list_of_podcasts: [Feed]?
    var current_podcast_index : Int?
    var current_podcast: Feed?
    var player:AVPlayer!
    var playerItem: AVPlayerItem!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_author: UILabel!
    
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var lbl_createddate: UILabel!
    
    @IBOutlet weak var playbackSlider: UISlider!
    
    @IBOutlet weak var lbl_summary: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.current_podcast = self.list_of_podcasts?[current_podcast_index!];
        DispatchQueue.main.async {
            self.configurePageAccordingToPodcast(feed:self.current_podcast!);
        }
    }

    func configurePageAccordingToPodcast(feed:Feed){
        if(feed != nil){
            self.lbl_title.text = feed.title;
            self.lbl_author.text = feed.author;
            self.lbl_summary.text = feed.summary;
            self.lbl_createddate.text = feed.pubDate;
            self.playbackSlider.minimumValue = 0;
            playOrPausePodcast(url:feed.media_url)
          
        }
    }
    
    @IBAction func changeProgress(_ sender: Any) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        if(self.player == nil){
            playerItem = AVPlayerItem(url: URL(string: (self.current_podcast?.media_url)!)!)
            player = AVPlayer(playerItem: playerItem)
        }
        else{
            player!.seek(to: targetTime)
        }
       
            player?.play()
        DispatchQueue.main.async {
            self.btnplay.imageView?.image = #imageLiteral(resourceName: "pauseimg")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func playPreviousPodcast(_ sender: Any) {
        if(self.current_podcast_index! - 1 < 0){
            showAlertMessage(header: "End Of List", displayMessage: "Reached Beginning of the list")
        }
        else{
            player = nil;
            self.current_podcast_index = self.current_podcast_index! - 1;
            self.current_podcast = self.list_of_podcasts![self.current_podcast_index!];
            configurePageAccordingToPodcast(feed: self.list_of_podcasts![self.current_podcast_index!])
        }
    }

    @IBAction func playNextPodcast(_ sender: Any) {
        if(self.current_podcast_index! + 1 >= (self.list_of_podcasts?.count)!){
            showAlertMessage(header: "End Of List", displayMessage: "Reached end of the list")
        }
        else{
            player = nil;
            self.current_podcast_index = self.current_podcast_index! + 1;
            self.current_podcast = self.list_of_podcasts![self.current_podcast_index!];
            configurePageAccordingToPodcast(feed: self.list_of_podcasts![self.current_podcast_index!])
            
            
        }
    }
    
   
    @IBAction func playOrPauseCurrentPodcast(_ sender: Any) {
        playOrPausePodcast(url:(self.current_podcast?.media_url)!)
    }
    
    
    func showAlertMessage(header:String, displayMessage:String){
        let alertController = UIAlertController(title: header, message: displayMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func playOrPausePodcast(url:String){
        if(self.player == nil){
            playerItem = AVPlayerItem(url: URL(string: url)!)
            player = AVPlayer(playerItem: playerItem)
        }
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider!.value = Float ( time );
            }
        }
        let dur = playerItem.asset.duration;
        let seconds = CMTimeGetSeconds(dur);
        self.playbackSlider.maximumValue = Float(seconds)
        if player?.rate == 0
        {
            player!.play()
            DispatchQueue.main.async {
                self.btnplay.imageView?.image = #imageLiteral(resourceName: "pauseimg")
            }
        } else {
            player!.pause()
            DispatchQueue.main.async {
                self.btnplay.imageView?.image = #imageLiteral(resourceName: "playimg");
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        player.pause();
    }
}
