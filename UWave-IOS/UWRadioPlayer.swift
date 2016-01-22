//
//  RadioPlayer.swift
//  RadioApp
//
//  Created by Jonathan Velazquez on 11/7/15.
//  Copyright © 2015 Jonathan Velazquez. All rights reserved.
//

import Foundation
import AVFoundation

class UWRadioPlayer: NSObject {
    
    
    static let sharedInstance = UWRadioPlayer()
    private var player: AVPlayer!
    private var playerItem = AVPlayerItem(URL: NSURL(string: "http://live.uwave.fm:8000/listen-128.mp3")!)
    private var isPlaying = false
    
    override init() {
        super.init()
        player = AVPlayer(playerItem: playerItem)
        playerItem.addObserver(self, forKeyPath: "timedMetadata", options: .New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "timedMetadata" {
            NSNotificationCenter.defaultCenter().postNotificationName(UWNewSongNotification, object: nil)
        }
        
        

    }
    
    func play() {
        if (!isPlaying) {
            player.play()
        }
        player.muted = false
        isPlaying = true
    }
    
    func pause() {
        player.muted = true
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func checkMetadata() {
        let data = self.player.currentItem?.asset.commonMetadata
        print(data)
    }
    
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
    
}