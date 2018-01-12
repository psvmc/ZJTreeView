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
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var viewLeftCons: NSLayoutConstraint!
    
    @IBOutlet weak var lineTopImageView: UIImageView!
    @IBOutlet weak var lineBottomImageView: UIImageView!
    
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
        
        if(itemData.level == 0){
            self.contentView.backgroundColor = UIColor.init(red: 244.0/255, green: 244.0/255, blue: 244.0/255, alpha: 244.0/255);
            self.lineTopImageView.isHidden = false;
            if(itemData.childArr == nil){
                self.lineBottomImageView.isHidden = false;
            }else{
                if(itemData.isexpand){
                    self.lineBottomImageView.isHidden = false;
                }else{
                    self.lineBottomImageView.isHidden = true;
                }
            }
            
            
        }else{
            self.contentView.backgroundColor = UIColor.white;
            self.lineTopImageView.isHidden = true;
            self.lineBottomImageView.isHidden = true;
        }
        
        viewLeftCons.constant = CGFloat(itemData.level * 20)
        
    }
    
}
