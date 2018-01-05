//
//  ViewController.swift
//  ZJTreeView
//
//  Created by 张剑 on 2018/1/5.
//  Copyright © 2018年 张剑. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    public var tableData:[TreeItemModel] = [];
    public var isShowAllName = true;
    
    private var tableDataBak:[TreeItemModel] = [];
    private var buttonPars:[Int:IndexPath] = [:];

    public var selectIdArr:[Int] = [];
    public var selectNameArr:[String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        self.initData()
    }
    
    func initTableView(){
        //设置分割线样式
        self.tableView.separatorStyle = .none;
        self.tableView.register(UINib.init(nibName: "TreeItemCell", bundle: nil), forCellReuseIdentifier: "TreeItemCell");
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.estimatedRowHeight = 60;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
    }
    
    func initData(){
        let itemModel01 = TreeItemModel.init(id: 1, name: "语文", level: 0, childArr: [
            TreeItemModel.init(id: 2, name: "第一章", level: 1, childArr: [
                TreeItemModel.init(id: 3, name: "第1节", level: 2, childArr: nil),
                TreeItemModel.init(id: 4, name: "第2节", level: 2, childArr: nil),
                TreeItemModel.init(id: 5, name: "第3节", level: 2, childArr: nil)
                ]),
            TreeItemModel.init(id: 6, name: "第二章", level: 1, childArr: [
                TreeItemModel.init(id: 7, name: "第1节", level: 2, childArr: nil),
                TreeItemModel.init(id: 8, name: "第2节", level: 2, childArr: nil),
                TreeItemModel.init(id: 9, name: "第3节", level: 2, childArr: nil),
                TreeItemModel.init(id: 10, name: "第4节", level: 2, childArr: nil),
                TreeItemModel.init(id: 11, name: "第5节", level: 2, childArr: nil),
                TreeItemModel.init(id: 12, name: "第6节", level: 2, childArr: nil),
                ])
            ])
        
        let itemModel02 = TreeItemModel.init(id: 13, name: "数学", level: 0, childArr: [
            TreeItemModel.init(id: 14, name: "第一章", level: 1, childArr: [
                TreeItemModel.init(id: 15, name: "第1节", level: 2, childArr: nil)
                ]),
            TreeItemModel.init(id: 16, name: "第二章", level: 1, childArr: [
                TreeItemModel.init(id: 17, name: "第1节", level: 2, childArr: nil),
                TreeItemModel.init(id: 18, name: "第2节", level: 2, childArr: nil),
                TreeItemModel.init(id: 19, name: "第3节", level: 2, childArr: nil),
                TreeItemModel.init(id: 20, name: "第4节", level: 2, childArr: nil),
                TreeItemModel.init(id: 21, name: "第5节", level: 2, childArr: nil),
                TreeItemModel.init(id: 22, name: "第6节", level: 2, childArr: nil),
                ])
            ])
        
        let itemModel03 = TreeItemModel.init(id: 13, name: "物理", level: 0, childArr: nil)
        
        self.tableData.append(itemModel01);
        self.tableData.append(itemModel02);
        self.tableData.append(itemModel03);
        self.tableView.reloadData();
        
        //原始数据做个备份
        DispatchQueue.global().async {
            for item in self.tableData{
                self.tableDataBak.append(item);
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData  = self.tableData[indexPath.row];
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TreeItemCell", for: indexPath) as! TreeItemCell;
        cell.selectionStyle = .none
        cell.setItemData(itemData: itemData);
        cell.actionButton.addTarget(self, action: #selector(actionButtonClick(button:)), for: UIControlEvents.touchUpInside)
        
        let tagNum = indexPath.section*1000000 + indexPath.row;
        cell.actionButton.tag = tagNum;
        self.buttonPars[tagNum] = indexPath;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemData = self.tableData[indexPath.row];
        itemData.isselect = !itemData.isselect;
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        if(itemData.isselect){
            self.checkItem(itemData: itemData);
        }else{
            self.uncheckItem(itemData: itemData)
        }
        self.tableView.reloadData()
    }
    
    
    @objc func actionButtonClick(button:UIButton){
        if let indexPath = self.buttonPars[button.tag]{
            let itemData = self.tableData[indexPath.row];
            if(itemData.childArr != nil){
                if(!itemData.isexpand){
                    self.expandTableView(indexPath: indexPath);
                }else{
                    self.foldTableView(indexPath: indexPath);
                }
            }
        }
    }
    
    func expandTableView(indexPath:IndexPath){
        let itemData = self.tableData[indexPath.row];
        if let childArr = itemData.childArr{
            itemData.isexpand = true;
            self.tableView.beginUpdates();
            self.tableData.insert(contentsOf: childArr, at: indexPath.row + 1)
            var indexPathArr:[IndexPath] = [];
            for index in 0 ..< childArr.count{
                indexPathArr.append(IndexPath.init(row: indexPath.row + index + 1, section: indexPath.section))
            }
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            self.tableView.insertRows(at: indexPathArr, with: UITableViewRowAnimation.bottom)
            self.tableView.endUpdates();
            self.resetTag();
        }
    }
    
    func foldTableView(indexPath:IndexPath){
        let itemData = self.tableData[indexPath.row];
        if let _ = itemData.childArr{
            itemData.isexpand = false;
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            self.tableView.beginUpdates();
            
            var indexPathArr:[IndexPath] = [];
            
            for i in indexPath.row+1 ..< self.tableData.count{
                if(self.tableData[i].level > itemData.level){
                    indexPathArr.append(IndexPath.init(row: i, section: indexPath.section))
                }else{
                    break;
                }
            }
            if(indexPathArr.count > 0){
                for i in indexPathArr[0].row ..< indexPathArr[indexPathArr.count-1].row+1{
                    self.tableData[i].isexpand = false;
                }
                self.tableData.removeSubrange(Range<Int>.init(uncheckedBounds: (lower: indexPathArr[0].row, upper: indexPathArr[indexPathArr.count-1].row+1)))
                self.tableView.deleteRows(at: indexPathArr, with: UITableViewRowAnimation.fade)
            }
            self.tableView.endUpdates();
            self.resetTag();
        }
    }
    
    
    
    //选中项
    func checkItem(itemData:TreeItemModel){
        //选中所有子集
        if let childArr = itemData.childArr{
            for itemData2 in childArr{
                itemData2.isselect = true;
                self.checkItem(itemData: itemData2);
            }
        }
        //如果所有同级都被选中则选中父级
        var parentItem = self.getParentItem(itemData: itemData);
        while(parentItem != nil){
            if(parentItem!.childArr != nil){
                if(self.isAllChildCheck(itemData: parentItem!)){
                    parentItem?.isselect = true;
                    parentItem = self.getParentItem(itemData: parentItem!)
                }else{
                    break;
                }
            }else{
                break;
            }
        }
    }
    
    //取消选中项
    func uncheckItem(itemData:TreeItemModel){
        //取消所有子级的选中
        if let childArr = itemData.childArr{
            for itemData2 in childArr{
                itemData2.isselect = false;
                self.uncheckItem(itemData: itemData2);
            }
        }
        //取消所有父级的选中
        var parentItem = self.getParentItem(itemData: itemData);
        while(parentItem != nil){
            parentItem?.isselect = false;
            parentItem = self.getParentItem(itemData: parentItem!)
        }
    }
    
    //获取父级
    func getParentItem(itemData:TreeItemModel) -> TreeItemModel?{
        for itemData2 in self.tableData{
            if let childArr = itemData2.childArr{
                for itemData3 in childArr{
                    if(itemData3.isEqual(itemData)){
                        return itemData2;
                    }
                }
            }
        }
        return nil;
    }
    
    //是否子节点全部选中
    func isAllChildCheck(itemData:TreeItemModel) -> Bool{
        if let childArr = itemData.childArr{
            for item in childArr{
                if(!item.isselect){
                    return false;
                }
            }
        }
        return true;
    }
    
    func resetTag(){
        for i in 0 ..< self.tableData.count{
            let indexPath = IndexPath.init(row: i, section: 0);
            if let itemCell = self.tableView.cellForRow(at: indexPath) as? TreeItemCell{
                let tagNum = indexPath.section*1000000 + indexPath.row;
                itemCell.actionButton.tag = tagNum;
                self.buttonPars[tagNum] = indexPath;
            }
        }
    }
    
    //重置
    @IBAction func resetClick(_ sender: Any) {
        DispatchQueue.global().async {
            for item in self.tableDataBak{
                item.isselect = false;
                self.unSelectSonItem(itemData: item)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }
        
    }
    
    
    //确认
    @IBAction func okClick(_ sender: Any) {
        self.selectIdArr.removeAll();
        self.selectNameArr.removeAll();
        DispatchQueue.global().async {
            for item in self.tableDataBak{
                if(item.isselect){
                    self.selectIdArr.append(item.id)
                    self.selectNameArr.append(item.name)
                }
                self.getCheckSonItemWithName(itemData: item, itemName: item.name)
            }
            
            print("选中的id为：\(self.selectIdArr)")
            print("选中的name为：\(self.selectNameArr)")
        }
    }
    
    
    //依次遍历所有的子节点
    func getCheckSonItemWithName(itemData:TreeItemModel,itemName:String){
        if let childArr = itemData.childArr{
            for itemData2 in childArr{
                var tempItemName = "";
                if(itemName != ""){
                    tempItemName = "\(itemName)-\(itemData2.name ?? "")"
                }else{
                    tempItemName = "\(itemData2.name ?? "")"
                }
                if(itemData2.isselect){
                    self.selectIdArr.append(itemData2.id)
                    if(self.isShowAllName){
                        self.selectNameArr.append(tempItemName)
                    }else{
                        self.selectNameArr.append(itemData2.name)
                    }
                }
                self.getCheckSonItemWithName(itemData: itemData2,itemName:tempItemName);
            }
        }
    }
    
    //取消选中不检查同级
    func unSelectSonItem(itemData:TreeItemModel){
        if let childArr = itemData.childArr{
            for itemData2 in childArr{
                itemData2.isselect = false;
                self.unSelectSonItem(itemData: itemData2);
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

