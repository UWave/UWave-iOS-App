//
//  UWNetworkingEngine.swift
//  UWave-IOS
//
//  Created by George Urick on 12/17/15.
//  Copyright © 2015 HappinessDevelopment. All rights reserved.
//

import UIKit
//import Alamofire

class UWNetworkingEngine: NSObject, NSURLConnectionDataDelegate {
    
    var responseData: NSMutableData?
    
    typealias UWMetadataCompletionBlock = (results: UWSongMetadata?, success: Bool) -> Void
    
    
    func songMetadata(completion: UWMetadataCompletionBlock) {
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://uwave.fm/listen/now-playing.json")!)
        urlRequest.HTTPMethod = "GET"
        urlRequest.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithRequest(urlRequest) { (data, response, error) in
            do {
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                
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
                completion(results: metadata, success: true)
            }
            catch _ {
                completion(results: nil, success: false)
            }
        }.resume()
    }
}
