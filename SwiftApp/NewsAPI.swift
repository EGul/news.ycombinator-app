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
    
    func getTopStories(completion: (result: NSMutableArray, error: NSError?) -> Void) {
        
        getTopStoryIds( { (result: NSArray) in
            
            let toResult: NSMutableArray = []
            for i in 0...29 {
                toResult.addObject(result[i])
            }
            
            self.getStoriesFromIds(toResult, completion: { (result: NSMutableArray) in
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
    
    func dataToArray(data: NSData?, completion: (result: NSArray) -> Void) {
        
        do {
            if let arr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray {
                completion(result: arr)
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
    
    func getTopStoryIds(completion: (result: NSArray) -> Void, error: (error: NSError?) -> Void) {
        
        let url = NSURL(string: idsURL)
        
        get(url!, completion: { (data: NSData?) in
            
            self.dataToArray(data) { (result: NSArray) in
                completion(result: result)
            }
            
        }, error: { (err: NSError?) in
            error(error: err)
        })
        
    }
    
    func getStoriesFromIds(ids: NSMutableArray, completion: (result: NSMutableArray) -> Void, error: (error: NSError?) -> Void) {
        
        if ids.count == 0 {
            completion(result: NSMutableArray())
        }
        else {
            
            let current = String(ids[0])
            ids.removeObjectAtIndex(0)
            
            let tempArr = NSMutableArray()
            
            getStoryFromId(current, completion: { (result: NSDictionary) in
                
                tempArr.addObject(result)
                
                self.getStoriesFromIds(ids, completion: { (result: NSMutableArray) in
                    
                    tempArr.addObjectsFromArray(result as [AnyObject])
                    
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