//
//  RDLoadOperation.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/19.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

class RDLoadOperation<T> : Operation {
    var data:T? = nil
    
    func getError() -> Error? {
        return  nil
    }
    
    override func main() {
    }
    
    override var isConcurrent: Bool {
        return true
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
}
