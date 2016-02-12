//
//  RadioPlayer.swift
//  RadioApp
//
//  Created by Jonathan Velazquez on 11/7/15.
//  Copyright © 2015 Jonathan Velazquez. All rights reserved.
//

import Foundation
import AFSoundManager
import AVFoundation
import MediaPlayer

class UWRadioPlayer: NSObject, AVAudioSessionDelegate {
    
    
    private static let radioPlayer = UWRadioPlayer()
    private var player: AFSoundPlayback!
//    private var playerItem = AVPlayerItem(URL: NSURL(string: "http://live.uwave.fm:8000/listen-128.mp3")!)
    private var mediaPlayer: MPMusicPlayerController!
    
    private var songData: UWSongMetadata?
    
    override init() {
        super.init()
        
        let item = AFSoundItem(streamingURL: NSURL(string: "http://live.uwave.fm:8000/listen-128.mp3")!)
        self.player = AFSoundPlayback(item: item)
        self.player.pause()
        self.player.player.currentItem?.addObserver(self, forKeyPath: "timedMetadata", options: .New, context: nil)
        self.player?.listenFeedbackUpdatesWithBlock(nil, andFinishedBlock: nil)
//        self.player = AFSoundQueue(item: )
//        player.addObserver(self, forKeyPath: "status", options: .New, context: nil)
//        playerItem.addObserver(self, forKeyPath: "timedMetadata", options: .New, context: nil)
        
//        [NSNoti addObserver: self
//            selector: @selector (handlePlaybackStateChanged:)
//        name: MixerHostAudioObjectPlaybackStateDidChangeNotification
//        object: audioObject];
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
            if self.player.player.status == AVPlayerStatus.ReadyToPlay {
                print("ready to play")
            }
        }
    }
    
    
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func toggle() {
        if player.player.rate > 0 {
            pause()
        } else {
            play()
        }
    }
    
    
    func currentlyPlaying() -> Bool {
        return player.player.rate > 0
    }
    
}