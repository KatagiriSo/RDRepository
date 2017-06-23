//
//  RDRecordListOperation.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/19.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

// https://ja.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&rnlimit=10&format=jsonfm&utf8=
class RDWikipediaOperation : RDLoadOperation<[RDWikipediaRecord]> {
    
    private let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
    
    override func load() -> Error? {
        let error = super.load()
        
        let url = NSURL(string: "https://ja.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&rnlimit=10&format=jsonfm&utf8=")!
        let task = URLSession.shared.dataTask(with:url.absoluteURL!) {[weak self] (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                } catch {
                    print("s e")
                }
            }
            
            print("response \(response)")
            print("error \(error)")
            self?.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        
        return error
    }
}
