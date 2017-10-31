//
//  Feed.swift
//  Homework2
//
//  Created by Dhulipala, Rama Vamshi Krishna on 10/21/17.
//  Copyright © 2017 Shehab, Mohamed. All rights reserved.
//

import UIKit

class Feed: NSObject {
    let title:String;
    let author:String;
    let media_url:String;
    let pubDate:String;
    let summary:String;
    var isPlaying:Bool;
    init(title:String, author:String, media_url:String, pubDate:String, summary:String, isPlaying:Bool) {
        self.title = title;
        self.author = author;
        self.media_url = media_url;
        self.pubDate = pubDate;
        self.summary = summary;
        self.isPlaying = isPlaying;
    }
}
