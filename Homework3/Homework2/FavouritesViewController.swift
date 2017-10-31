//
//  FavouritesViewController.swift
//  Homework2
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/22/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import AVFoundation

class FavouritesViewController: UITableViewController, OptionButtonsDelegatee {
    var current_selected_feed : Feed!
    var player:AVPlayer!
    var playerItem: AVPlayerItem!
    var previouspodcast : String = ""
var list_of_favourite_feeds:[Feed]? = [];
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tc = self.parent?.parent as! MyTabController;
        self.list_of_favourite_feeds = tc.list_of_favourite_feeds;
        self.tableView.reloadData();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (list_of_favourite_feeds?.count !=  0){
            return 1;
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list_of_favourite_feeds?.count)!;
    }
    
    
    func removePodcastFromFavourites(at index: IndexPath) {
        if(self.current_selected_feed.media_url == self.list_of_favourite_feeds![index.row].media_url){
            player = nil
            pauseCurrentSelectedSong();
        }
            self.list_of_favourite_feeds?.remove(at: index.row);
            let tc = self.parent?.parent as! MyTabController;
            tc.list_of_favourite_feeds?.remove(at: index.row);
            self.tableView.reloadData();
            self.showAlertMessage(header:"Success", displayMessage: "Item Removed From Favourites!!!");
    }
    
    func showAlertMessage(header:String, displayMessage:String){
        let alertController = UIAlertController(title: header, message: displayMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavouritesCellController
        let current_feed = self.list_of_favourite_feeds![indexPath.row];
        cell.delegate = self;
        cell.indexPath = indexPath
        cell.media_url = current_feed.media_url;
        cell.lbl_feedtitle.text = current_feed.title;
        cell.lbl_date.text = "Created On " + current_feed.pubDate;
        cell.lbl_author.text = current_feed.author;
        if(current_feed.isPlaying){
            DispatchQueue.main.async {
                cell.btnplay.imageView?.image = #imageLiteral(resourceName: "pauseimg")
            }
        }else{
            DispatchQueue.main.async {
                cell.btnplay.imageView?.image = #imageLiteral(resourceName: "playimg")
            }
        }
        return cell
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(self.list_of_favourite_feeds?.count != 0){
            return true;
        }
        return false;
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DisplayViewController;
        vc.list_of_podcasts = self.list_of_favourite_feeds;
        vc.current_podcast_index = self.tableView.indexPathForSelectedRow?.row;
    }
    func playOrPausePodcatsAccordingly(at index: IndexPath) {
        current_selected_feed = self.list_of_favourite_feeds![index.row];
        if(player == nil){
            playerItem = AVPlayerItem(url: URL(string: (current_selected_feed?.media_url)!)!)
            player = AVPlayer(playerItem: playerItem)
        }
        if(player != nil && current_selected_feed.media_url != previouspodcast){
            playerItem = AVPlayerItem(url: URL(string: current_selected_feed.media_url)!)
            player = AVPlayer(playerItem: playerItem)
        }
        
        if player?.rate == 0
        {
            player!.play()
            self.playOnlySelectedSong();
            
        } else {
            player!.pause()
            self.pauseCurrentSelectedSong()
        }
        self.previouspodcast = current_selected_feed.media_url;
        self.tableView.reloadData();
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(player != nil){
            self.stopAll();
            self.tableView.reloadData()
            player.pause();
            player = nil;
        }
    }
    
    func playOnlySelectedSong(){
        for feed in self.list_of_favourite_feeds! {
            if(feed.media_url == current_selected_feed.media_url){
                feed.isPlaying = true;
            }
            else{
                feed.isPlaying = false;
            }
        }
    }
    
    func pauseCurrentSelectedSong(){
        for feed in self.list_of_favourite_feeds! {
            if(feed.media_url == current_selected_feed.media_url){
                feed.isPlaying = false;
            }
        }
    }
    func stopAll(){
        for feed in self.list_of_favourite_feeds! {
            feed.isPlaying = false;
        }
    }
    
}

