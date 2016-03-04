//
//  RadioPlayer.swift
//  RadioApp
//
//  Created by Jonathan Velazquez on 11/7/15.
//  Copyright © 2015 Jonathan Velazquez. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class UWRadioPlayer: NSObject, AVAudioSessionDelegate {
    
    
    private static let radioPlayer = UWRadioPlayer()
    private var player: AVPlayer!
    private var mediaPlayer: MPMusicPlayerController!
    
    private var songData: UWSongMetadata?
    
    override init() {
        super.init()
        setupPlayer()
    }
    
    private var shouldPlayAfterReload = false
    private var failedToStart = false
    
    var didEnterBackground = false
    
    private func setupPlayer() -> Bool {
        if (self.player != nil) {
            
            if (didEnterBackground || failedToStart) {
                self.player.currentItem?.removeObserver(self, forKeyPath: "timedMetadata")
                self.player.removeObserver(self, forKeyPath: "status")
                self.player.pause()
                if (UIApplication.sharedApplication().applicationState == UIApplicationState.Active) {
                    didEnterBackground = false
                }
                
                
            }
            else {
                return true
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                withOptions: .DefaultToSpeaker)
        } catch _ as NSError {
            failedToStart = true
            NSNotificationCenter.defaultCenter().postNotificationName(UWFailedToStartNotification, object: nil)
        }
        
        
        
        
        let item = AVPlayerItem(URL: NSURL(string: "http://live.uwave.fm:8000/listen-128.mp3")!)
//        let item = AFSoundItem(streamingURL: NSURL(string: "http://live.uwave.fm:8000/listen-128.mp3")!)
        self.player = nil
        self.player = AVPlayer(playerItem: item)
        if self.shouldPlayAfterReload {
            self.player.play()
            self.shouldPlayAfterReload = false
        }
        else {
            self.pause()
        }
        self.player.currentItem?.addObserver(self, forKeyPath: "timedMetadata", options: .New, context: nil)
        self.player.addObserver(self, forKeyPath: "status", options: .New, context: nil)
        return false
    }
    
    func songStalled(notification: NSNotification) {
        print("Stalled")
    }
    
    func beginInterruption() {
        
    }
    
    func setSongData(data: UWSongMetadata) {
        
        
        songData = data
        
    }
    
    func getSongTitle() -> String? {
        if (songData != nil) {
            return songData!.title
        }
        return nil
    }
    
    func getSongArtist() -> String? {
        if (songData != nil) {
            return songData!.artist
        }
        return nil
    }
    
    func getSongAlbum() -> String? {
        if (songData != nil) {
            return songData!.album
        }
        return nil
    }
    
    
    class func sharedInstance() -> UWRadioPlayer {
        return radioPlayer
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "timedMetadata" {
            NSNotificationCenter.defaultCenter().postNotificationName(UWNewSongNotification, object: nil)
        }
        else if keyPath == "status" {
            if self.player.status == AVPlayerStatus.Failed {
                NSNotificationCenter.defaultCenter().postNotificationName(UWFailedToStartNotification, object: nil)
            }
        }
    }
    
    
    func play() {
        shouldPlayAfterReload = true
        if self.setupPlayer() {
            self.player.play()
        }
        Appirater.userDidSignificantEvent(true)
    }
    
    func pause() {
        player.pause()
    }
    
    func toggle() {
        if player.rate > 0 {
            pause()
        } else {
            play()
        }
    }
    
    
    func currentlyPlaying() -> Bool {
        if player == nil { return false; }
        return player.rate > 0
    }
    
}