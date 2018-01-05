//
//  ZJJsonUtil.swift
//  SaitongPlatform
//
//  Created by 张剑 on 2017/11/21.
//  Copyright © 2017年 张剑. All rights reserved.
//

import Foundation
class ZJJsonUtil{
    
    static func toJsonStr<T>(_ value: T) -> String where T : Encodable{
        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(value)
        return String(data: data, encoding: .utf8)!
    }
    
}
