//
//  UWApp.swift
//  UWave-IOS
//
//  Created by George Urick on 12/17/15.
//  Copyright © 2015 HappinessDevelopment. All rights reserved.
//

import UIKit

let UWNewSongNotification = "UWNewSongNotification"

class UWApp: NSObject {
    
    private static let app: UWApp = UWApp()
    let networkingEngine = UWNetworkingEngine()
    
    private override init() {
        super.init()
    }
    
    class func sharedInstance() -> UWApp {
        return self.app
    }
    

}
