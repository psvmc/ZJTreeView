//
//  TreeItemModel.swift
//  ZJTreeView
//
//  Created by 张剑 on 2018/1/5.
//  Copyright © 2018年 张剑. All rights reserved.
//

import Foundation

class TreeItemModel:NSObject,Codable{
    var id: Int!
    var name: String!
    var level: Int!
    var childArr: [TreeItemModel]?
    var isselect: Bool = false;
    var isexpand: Bool = false;
    
    required init(id:Int,name:String,level:Int,childArr:[TreeItemModel]?){
        self.id = id
        self.name = name
        self.level = level
        self.childArr = childArr
    }
}
