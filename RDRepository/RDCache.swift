//
//  RDCache.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/19.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

class RDCache<T, O:RDLoadOperation<T>>  {
    private var cache:T? = nil
    private let expireInterval:TimeInterval
    private let queue:OperationQueue = OperationQueue()
    private var lastLoadDateTime:Date? = nil
    private var isLoading:Bool = false
    private var loadCompletions:[(T?, Error?) -> Void] = []
    
    let makeLoadOperation:()->O;
    
    required init(expireInterval:TimeInterval, operationBlock:@escaping ()->O) {
        self.expireInterval = expireInterval
        self.makeLoadOperation = operationBlock
    }
    
    deinit {
        clear()
    }
    
    func clear() {
        queue.cancelAllOperations()
        queue.waitUntilAllOperationsAreFinished()
        cache = nil
        lastLoadDateTime = nil
    }
    
    func isExpired() ->Bool {
        
        guard expireInterval >= 0.0 else {
            return lastLoadDateTime == nil ? true : false
        }
        
        if expireInterval == 0.0 {
            return true
        }
        
        guard let lastLoadDateTime = self.lastLoadDateTime else {
            return true
        }
        
        let expireDateTime = lastLoadDateTime.addingTimeInterval(expireInterval)
        let isExpired =  expireDateTime < Date()
        
        return isExpired
    }
    
    
    
    func load() {
        if isExpired() {
            reload()
        } else {
            loadFinish(error:nil)
        }
    }
    
    
    func reload() {
        guard !self.isLoading else {
            return
        }
        
        let operation = makeLoadOperation()
        
        self.isLoading = true
        
        operation.completionBlock = { [weak self] in
            if operation.getError() == nil {
                self?.reloadFinish(operation:operation)
                self?.lastLoadDateTime = Date()
            }
            self?.isLoading = false
            self?.loadFinish(error: operation.getError())
            
            operation.completionBlock = nil
        }
        
        queue.addOperation(operation)
    }
    
    func setNeedsReload() {
        queue.cancelAllOperations()
        queue.waitUntilAllOperationsAreFinished()
        lastLoadDateTime = nil
    }
    
    func load(completion:@escaping (T?, Error?) -> Void) {
        objc_sync_enter(self.loadCompletions)
        loadCompletions = loadCompletions + [completion]
        objc_sync_exit(self.loadCompletions)
        
        self.load()
    }
    
    func reload(completion:@escaping (T?, Error?) -> Void) {
        objc_sync_enter(self.loadCompletions)
//        loadCompletions.append(completion)
        loadCompletions = loadCompletions + [completion]
        objc_sync_exit(self.loadCompletions)
        
        self.reload()
    }
    
    func loadFinish(error: Error?) {
        let completions = self.loadCompletions
        let result = cache
        loadCompletions = []
        DispatchQueue.global().async {
            completions.forEach {
                $0(result, error)
            }
        }
    }
    
    func reloadFinish(operation: O) {
        cache = operation.data
    }
    
}
