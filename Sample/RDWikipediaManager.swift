//
//  RDWikipediaManager.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/19.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

class RDWikipediaManager {
    static let share:RDWikipediaManager = RDWikipediaManager()
    
    let cache:RDWikipediaCache = RDWikipediaCache(expireInterval:0.0, operationBlock:{
        return RDWikipediaOperation()
    })
    
    private init() {
        
    }
    
    func loadList(completion:@escaping ([RDWikipediaRecord]?,Error?) -> Void) {
        cache.load(completion: completion)
    }
    
    func reloadList(completion:@escaping ([RDWikipediaRecord]?,Error?) -> Void) {
        cache.reload(completion: completion)
    }
    
    func setNeedReload() {
        cache.setNeedsReload()
    }
    
}
