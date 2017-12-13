//
//  WGTextView.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/14.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit
import SnapKit

class WGTextView: UITextView {

    fileprivate let placeColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    public var maxLength: Int = 200
    
    public var placeHolder: String? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var placeHolderColor: UIColor?
    
    fileprivate var textCountString: String?{
        didSet{
           setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        // 设置默认字体
        self.font = UIFont.systemFont(ofSize: 15)
        //设置默认颜色
        self.textColor = UIColor.init(red: 53/255.0, green: 53/255.0, blue: 53/255.0, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        if self.text.count > 0 {
            let attrTextCountString = NSMutableAttributedString.init(string: textCountString ?? "")
            attrTextCountString.addAttributes([NSAttributedStringKey.font: self.font ?? 15,NSAttributedStringKey.foregroundColor : placeHolderColor ?? placeColor], range: NSMakeRange(0, textCountString?.count ?? 0))
            let size = attrTextCountString.size()
            attrTextCountString.draw(in: CGRect.init(x: rect.width - 5.0 - size.width, y: rect.height - 5.0 - size.height, width: size.width + 2, height: size.height + 2)) }
        
        if self.text.count > 0 { return }
        
        if  placeHolder != nil && placeHolder!.count > 0 {
            let attrPlaceHolder = NSMutableAttributedString.init(string: placeHolder!)
            attrPlaceHolder.addAttributes([NSAttributedStringKey.font: self.font ?? 15,NSAttributedStringKey.foregroundColor : placeHolderColor ?? placeColor], range: NSMakeRange(0, placeHolder!.count))
            let size = attrPlaceHolder.size()
            attrPlaceHolder.draw(in: CGRect.init(x: 5.0, y: 5.0, width: size.width + 2, height: size.height + 2))
        }
    }
    
    @objc func textDidChange(note: Notification){
        textCountString = "\(self.text.count)" + "\\" + "\(maxLength)"
        setNeedsDisplay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
