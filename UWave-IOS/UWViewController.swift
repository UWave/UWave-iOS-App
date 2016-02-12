//
//  ViewController.swift
//  RadioApp
//
//  Created by Jonathan Velazquez on 11/7/15.
//  Copyright © 2015 Jonathan Velazquez. All rights reserved.
//

import UIKit
import MediaPlayer

class UWViewController: UIViewController, UWPlayPauseDelegate {

    @IBOutlet weak var playButton: UWPlayPauseButton!

    let networkingEngine = UWApp.sharedInstance().networkingEngine
    
    var currentSong: UWSongMetadata?
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistAlbumTitle: UILabel!
    
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.playButton.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMetadata:", name: UWNewSongNotification, object: nil)
        
        self.updateMetadata(NSNotification(name: "Nil", object: nil))
    }
    
    func updateMetadata(notification: NSNotification) {
        self.playButton.setPlaying(UWRadioPlayer.sharedInstance().currentlyPlaying())
        
        self.networkingEngine.songMetadata { (results, success) -> Void in
            if (success) {
                self.currentSong = results!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.songTitle.hidden = false;
                    self.songTitle.hidden = false;
                    self.updateMediaPlayer(results!)
                    self.updateMetadataLabel(results!)
                })
            }
            else {
                self.songTitle.hidden = true;
                self.songTitle.hidden = true;
            }
        }
    }
    
    func updateMediaPlayer(song: UWSongMetadata) {
        
        let infoCenter = MPNowPlayingInfoCenter.defaultCenter()
        
        let artwork = MPMediaItemArtwork(image: UIImage(named: "swoosh-square 1024.png")!)
        
        infoCenter.nowPlayingInfo = [MPMediaItemPropertyTitle : song.title,
                                     MPMediaItemPropertyArtist : song.artist,
                                     MPMediaItemPropertyAlbumTitle : song.album,
                                     MPMediaItemPropertyArtwork : artwork];
        let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        let rewind = commandCenter.seekBackwardCommand
        rewind.enabled = false
        rewind.addTargetWithHandler { (command) -> MPRemoteCommandHandlerStatus in
            return MPRemoteCommandHandlerStatus.Success
        }
        let forward = commandCenter.seekForwardCommand
        
        forward.addTargetWithHandler { (command) -> MPRemoteCommandHandlerStatus in
            return .Success
        }
        forward.enabled = false
        let play = commandCenter.playCommand
        play.addTargetWithHandler { (command) -> MPRemoteCommandHandlerStatus in
//            self.playPauseButton(self.playButton, didToggle: true)
            return .Success
        }
        
        let pause = commandCenter.pauseCommand
        pause.addTargetWithHandler { (command) -> MPRemoteCommandHandlerStatus in
//            self.playPauseButton(self.playButton, didToggle: false)
            return .Success
        }
    }
    
    func updateMetadataLabel(song: UWSongMetadata) {
        var aSong = song
        if aSong.title.characters.count == 0 {
            aSong.title = "(No title)"
        }
        self.songTitle.text = aSong.title
        
        if aSong.artist.characters.count == 0 {
            aSong.artist = "(No artist)"
        }
        if aSong.album.characters.count == 0 {
            aSong.album = "(No album)"
        }
        self.artistAlbumTitle.text = "\(aSong.artist) - \(aSong.album)"
    }
    
    func playPauseButton(button: UWPlayPauseButton, didToggle status: Bool) {
        if status == true {
            UWRadioPlayer.sharedInstance().play()
        }
        else {
            UWRadioPlayer.sharedInstance().pause()
        }
    }
    
    
    
    
//    func toggle(){
//        if UWRadioPlayer.sharedInstance.currentlyPlaying(){
//            pauseRadio()
//        }else{
//            playRadio()
//        }
//    }
//    func playRadio(){
//        
//        let imageName = "UWavePauseButton.png"
//        
//        let image2 = UIImage(named: imageName)
//
//        
//        UWRadioPlayer.sharedInstance.play()
//            //playButton.setTitle("Pause", forState: UIControlState.Normal)
//        
//            playButton.setImage(image2, forState: UIControlState.Normal)
//        
//    }
//    func pauseRadio(){
//        let imageName3 = "UWavePlayButton.png"
//        let image3 = UIImage(named: imageName3)
//        
//        UWRadioPlayer.sharedInstance.pause()
//        //playButton.setTitle("Play", forState: UIControlState.Normal)
//        playButton.setImage(image3, forState: UIControlState.Normal)
//        
//    }
    
        
}




