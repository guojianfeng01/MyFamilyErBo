//
//  HomeTableViewCell.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/16.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit
import SnapKit

let identifyId = "HomeTableViewCellID"

class HomeTableViewCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate lazy var iconImage: UIImageView! = {
        let iconImage = UIImageView()
        self.contentView.addSubview(iconImage)
        return iconImage
    }()
    
    fileprivate lazy var timeTitleLabel: UILabel! = {
        let titleLabel = UILabel()
        titleLabel.font = kFont_12
        titleLabel.textColor = kColor_8
        titleLabel.textAlignment = .left
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    fileprivate lazy var nameLabel: UILabel! = {
        let titleLabel = UILabel()
        titleLabel.font = kFont_15
        titleLabel.textColor = kColor_4
        titleLabel.textAlignment = .left
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    fileprivate lazy var desLabel: UILabel! = {
        let titleLabel = UILabel()
        titleLabel.font = kFont_15
        titleLabel.textColor = kColor_5
        titleLabel.textAlignment = .left
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    fileprivate lazy var lineView: UIView! = {
        let lineView = UIView()
        lineView.backgroundColor = kColor_9
        self.contentView.addSubview(lineView)
        return lineView
    }()
}
//MARK: pubic
extension HomeTableViewCell{
    func updateUI(_ name: String?, _ des: String?, _ time: String?, _ icon: UIImage?) {
        iconImage.image = icon ?? UIImage(named: "placeHolder")
        nameLabel.text = name ?? "未设置标题"
        timeTitleLabel.text = time ?? "时间戳"
        desLabel.text = des ?? "详细描述"
    }
}

//MARK: private
extension HomeTableViewCell{
    fileprivate func configUI(){
        iconImage.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
            make.bottom.equalToSuperview().offset(-5)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImage.snp.top).offset(5)
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        
        desLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImage.snp.centerY)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalToSuperview().offset(-15)
        }
        
        timeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
