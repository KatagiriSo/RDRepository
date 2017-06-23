//
//  RDWikipediaRecord.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/19.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

struct RDWikipediaRecord : RDRecord {
    let id:Int
    let ns:Int
    let title:String
    
    init?(raw:JSONValue) {
        guard let id = raw.dictionary?["id"]?.number?.intValue else {
            return nil
        }
        
        guard  let ns = raw.dictionary?["ns"]?.number?.intValue else {
            return nil
        }
        
        guard let title = raw.dictionary?["title"]?.string else {
            return nil
        }
        self.id = id
        self.ns = ns
        self.title = title
    }
    
}
