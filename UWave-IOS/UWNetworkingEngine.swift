//
//  UWNetworkingEngine.swift
//  UWave-IOS
//
//  Created by George Urick on 12/17/15.
//  Copyright © 2015 HappinessDevelopment. All rights reserved.
//

import UIKit
import AFNetworking
import LGAudioStreamHelper

class UWNetworkingEngine: NSObject {
    
    
    func songMetadata(completion: (results: UWSongMetadata) -> Void) {
        
        let manager = AFHTTPSessionManager()
        let urlRequest = NSURLRequest(URL: NSURL(string: "http://www.uwave.fm/listen/now-playing.json")!)
        
        
        let task = manager.dataTaskWithRequest(urlRequest) { (request, response, error) -> Void in
            let parsedObject = response as! NSDictionary
            guard
                let title: String? = parsedObject["title"] as! String?,
                let artist: String? = parsedObject["artist"] as! String?,
                let album: String? = parsedObject["album"] as! String?,
                let year: String? = parsedObject["year"] as! String?,
                let cart: String? = parsedObject["cart"] as! String?,
                let length: String? = parsedObject["length"] as! String? where title != nil && artist != nil && album != nil && year != nil && cart != nil && length != nil
                else {
                    return
            }
            
            
            let metadata = UWSongMetadata(title: title!, artist: artist!, album: album!, year: Int(year!)!, length: Int(length!)!, cart: Int(cart!)!)
            completion(results: metadata)
            
        }
        task.resume()
        
    }
    
//    func songStream(completion: (results: UWSongMetadata) -> Void) {
//        
//        let manager = AFHTTPSessionManager()
//        let urlRequest = NSURLRequest(URL: NSURL(string: "http://live.uwave.fm:8000/listen-128.mp3.m3u")!)
//        
//        let task = manager.dataTaskWithRequest(urlRequest) { (request, response, error) -> Void in
//            
//            let dictionary = response as! NSDictionary
//            print(dictionary)
//            
//        }
//        task.resume()
//    }
}
