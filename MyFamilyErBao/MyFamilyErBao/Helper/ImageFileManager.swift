//
//  ImageFileManager.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/12/12.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit

class ImageFileManager: NSObject {
    static let IMAGE_NAME_SAPCE = "IMAGE_NAME_SAPCE"
    
    let fileManager: FileManager = FileManager()
    
    static let shared = ImageFileManager()
    
    private override init(){
        super.init()
    }
    
    func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String){
        if let imageData = UIImageJPEGRepresentation(currentImage, persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
        }
    }
    
    func fileFullPath(_ imageName: String) -> String {
        return filePath() + imageName
    }
    
    func filePath() -> String {
        return NSHomeDirectory().appending("/Documents/")
    }
    
    func getImage(_ fileFullPath: String) -> UIImage? {
        return  UIImage(contentsOfFile: fileFullPath)
    }
}
