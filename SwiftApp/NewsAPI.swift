//
//  GetData.swift
//  SwiftApp
//
//  Created by Evan on 10/28/15.
//  Copyright © 2015 none. All rights reserved.
//

import Foundation
import UIKit

class NewsAPI {
    
    let idsURL = "http://hacker-news.firebaseio.com/v0/topstories.json"
    let storyURL = "https://hacker-news.firebaseio.com/v0/item/"
    
    func getTopStories(completion: (result: [NSDictionary], error: NSError?) -> Void) {
        
        getTopStoryIds( { (result: [String]) in
            
            var toResult: [String] = []
            for i in 0...29 {
                toResult.append(result[i])
            }
            
            self.getStoriesFromIds(toResult, completion: { (result: [NSDictionary]) in
                
                completion(result: result, error: nil)
                }, error: { (err: NSError?) in
                    completion(result: [], error: err)
            })
            
            }, error: { (error: NSError?) in
                completion(result: [], error: error)
        })
        
    }
    
    func get(url: NSURL, completion: (data: NSData?) -> Void, error: (error: NSError?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, err) in
            
            if (err == nil) {
                completion(data: data)
            }
            else {
                error(error: err)
            }
            
        }
        
        task.resume()
        
    }
    
    func dataToArray(data: NSData?, completion: (result: [String]) -> Void) {
        
        do {
            if let arr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray {
                
                var toArray: [String] = []
                
                for e in arr {
                    toArray.append(NSString(format: "%d", (e as? Int)!) as String)
                }
                
                completion(result: toArray)
                
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func dataToDictionary(data: NSData?, completion: (result: NSDictionary) -> Void) {
        
        do {
            if let something = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                completion(result: something)
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func getTopStoryIds(completion: (result: [String]) -> Void, error: (error: NSError?) -> Void) {
        
        let url = NSURL(string: idsURL)
        
        get(url!, completion: { (data: NSData?) in
            
            self.dataToArray(data) { (result: [String]) in
                
                completion(result: result)
                
            }
            
        }, error: { (err: NSError?) in
            error(error: err)
        })
        
    }
    
    func getStoriesFromIds(var ids: [String], completion: (result: [NSDictionary]) -> Void, error: (error: NSError?) -> Void) {
        
        if ids.count == 0 {
            completion(result: [NSDictionary]())
        }
        else {
            
            let current = (ids.removeFirst())
            
            var tempArr: [NSDictionary] = []
            
            getStoryFromId(current, completion: { (result: NSDictionary) in
                
                tempArr.append(result)
                
                self.getStoriesFromIds(ids, completion: { (result: [NSDictionary]) in
                    
                    tempArr += result
                    
                    completion(result: tempArr)
                    
                }, error: { (err: NSError?) in
                    error(error: err)
                })
                
            }, error: { (err: NSError?) in
                error(error: err)
            })
            
        }
        
    }
    
    func getStoryFromId(storyId: String, completion: (result: NSDictionary) -> Void, error: (error: NSError?) -> Void) {
        
        let url = NSURL(string: storyURL + storyId + ".json")
        
        get(url!, completion: { (data: NSData?) in
            
            self.dataToDictionary(data) { (result: NSDictionary) in
                completion(result: result)
            }
            
        }, error: { (err: NSError?) in
            error(error: err)
        })
        
    }
    
}