//
//  TreeItemCell.swift
//  ZJTreeView
//
//  Created by 张剑 on 2018/1/5.
//  Copyright © 2018年 张剑. All rights reserved.
//

import UIKit

class TreeItemCell: UITableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var viewLeftCons: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setItemData(itemData:TreeItemModel)  {
        if(itemData.isselect){
            checkImageView.image = UIImage.init(named: "tree_check")
        }else{
            checkImageView.image = UIImage.init(named: "tree_uncheck")
        }
        
        titleLabel.text = itemData.name;
        if(itemData.childArr == nil){
            actionButton.isHidden = true;
        }else{
            actionButton.isHidden = false;
            if(itemData.isexpand){
                actionButton.setImage(UIImage.init(named: "tree_up"), for: UIControlState.normal);
            }else{
                actionButton.setImage(UIImage.init(named: "tree_down"), for: UIControlState.normal);
            }
        }
        
        viewLeftCons.constant = CGFloat(itemData.level * 20)
        
    }
    
}
