//
//  FeedsViewController.swift
//  Homework2
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/21/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit
import AVFoundation


class FeedsViewController: UITableViewController , XMLParserDelegate, OptionButtonsDelegate {
    var current_selected_feed : Feed!
    var player:AVPlayer!
    var playerItem: AVPlayerItem!

    var list_of_feeds:[Feed]? = [];
    var parser = XMLParser()
    var posts = NSMutableArray()
    var element = String()
    var feed_title, feed_summary, feed_media_url, feed_author ,feed_pubdate: String?
    var insideitem = false;
    var previouspodcast : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing();
        
    }
    
    func beginParsing()
    {
        parser = XMLParser(contentsOf: URL(string: "http://feed.thisamericanlife.org/talpodcast")!)!
        parser.delegate = self
        parser.parse()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName).isEqual("item")
        {
            insideitem = true;
        }
        if (elementName).isEqual("media:content") && self.insideitem == true{
            self.feed_media_url = attributeDict["url"]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (element.isEqual("title") && self.insideitem == true && string != "\n ") {
            self.feed_title = string
        } else if element.isEqual("itunes:author") {
            self.feed_author = string
        }
        else if element.isEqual("pubDate") && self.insideitem == true && string != "\n " {
            self.feed_pubdate = string.substring(to: string.index(string.startIndex, offsetBy: 16))
            print( self.feed_pubdate)
        }
        else if element.isEqual("itunes:summary") && self.insideitem == true {
            self.feed_summary = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName).isEqual("item") {
            if (self.feed_title != nil && self.feed_author != nil && self.feed_summary != nil) {
                list_of_feeds?.append(Feed(title: feed_title!,author: feed_author!,media_url: feed_media_url!, pubDate:feed_pubdate!, summary: self.feed_summary!, isPlaying: false));
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     override func numberOfSections(in tableView: UITableView) -> Int {
        if (list_of_feeds?.count !=  0){
            return 1;
        }
        return 0;
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list_of_feeds?.count)!;
    }
    

    func addPodcastToFavourites(at index: IndexPath) {
        let tc = self.parent?.parent as! MyTabController;
        if(tc.list_of_favourite_feeds?.contains(self.list_of_feeds![index.row]))!{
             self.showAlertMessage(header:"Message", displayMessage: "Item Already in Favourites!!!");
        }
        else{
            tc.list_of_favourite_feeds?.append(self.list_of_feeds![index.row])
            self.showAlertMessage(header:"Success", displayMessage: "Added to Favourites !!!");
        }
    }
    
    func showAlertMessage(header:String, displayMessage:String){
        let alertController = UIAlertController(title: header, message: displayMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedsCellController
        let current_feed = list_of_feeds![indexPath.row];
        cell.delegate = self
        cell.indexPath = indexPath
        cell.lbl_feedtitle.text = current_feed.title;
        cell.lbl_date.text = "Created On " + current_feed.pubDate;
        cell.lbl_author.text = current_feed.author
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

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(self.list_of_feeds?.count != 0){
            return true;
        }
        return false;
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DisplayViewController;
        vc.list_of_podcasts = self.list_of_feeds;
        vc.current_podcast_index = self.tableView.indexPathForSelectedRow?.row;
    }
    
    func playOrPausePodcatsAccordingly(at index: IndexPath) {
        current_selected_feed = self.list_of_feeds![index.row];
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
        for feed in self.list_of_feeds! {
            if(feed.media_url == current_selected_feed.media_url){
                feed.isPlaying = true;
            }
            else{
                feed.isPlaying = false;
            }
        }
    }
    
    func pauseCurrentSelectedSong(){
        for feed in self.list_of_feeds! {
            if(feed.media_url == current_selected_feed.media_url){
                feed.isPlaying = false;
            }
        }
    }
    func stopAll(){
        for feed in self.list_of_feeds! {
                feed.isPlaying = false;
        }
    }
    
}
