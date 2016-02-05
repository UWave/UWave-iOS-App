//
//  ViewController.swift
//  RadioApp
//
//  Created by Jonathan Velazquez on 11/7/15.
//  Copyright © 2015 Jonathan Velazquez. All rights reserved.
//

import UIKit

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
                    self.updateMetadataLabel(results!)
                })
            }
            else {
                self.songTitle.hidden = true;
                self.songTitle.hidden = true;
            }
        }
    }
    
    func updateMetadataLabel(song: UWSongMetadata) {
        self.songTitle.text = song.title
        self.artistAlbumTitle.text = "\(song.artist) - \(song.album)"
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




