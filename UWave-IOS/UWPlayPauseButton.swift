//
//  UWPlayPauseButton.swift
//  UWave-IOS
//
//  Created by George Urick on 12/16/15.
//  Copyright © 2015 HappinessDevelopment. All rights reserved.
//

import UIKit
import RSPlayPauseButton

protocol UWPlayPauseDelegate: NSObjectProtocol {
    
    func playPauseButton(button: UWPlayPauseButton, didToggle status: Bool)
    
}

class UWPlayPauseButton: AnimatablePlayButton {
    
    weak var delegate: UWPlayPauseDelegate!
    var animated = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.bgColor = UIColor.UWBlackColor()
        self.color = self.tintColor
        self.addTarget(self, action: "toggle:", forControlEvents: .TouchUpInside)
        self.select()
    }

    internal required init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    func toggle(sender: AnimatablePlayButton) {
        self.setPlaying(sender.selected)
        if delegate != nil {
            delegate?.playPauseButton(self, didToggle: self.playing())
        }
    }
    
    func playing() -> Bool {
        return !self.selected
    }
    
    func setPlaying(selected: Bool) {
        if (!selected) {
            self.select()
        }
        else {
            self.deselect()
        }
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
