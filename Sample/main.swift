//
//  main.swift
//  RDRepository
//
//  Created by 片桐奏羽 on 2017/06/19.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation


RDWikipediaManager.share.loadList { (list,error) in
    print("\(list)")
}


while true {
    Thread.sleep(forTimeInterval: 10)
    print("wait")
}













