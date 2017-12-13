//
//  AddViewController.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/13.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit
import SnapKit
import TZImagePickerController

class AddViewController: ViewController {
    fileprivate lazy var titleTextField = UITextField()
    fileprivate lazy var descriptionText = WGTextView()
    fileprivate lazy var imageView = UIView()
    fileprivate lazy var imageTitleLabel = UILabel()
    fileprivate lazy var photoView = PhotoView()
    var model: ImageModel? = ImageModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加"
        automaticallyAdjustsScrollViewInsets = false
        configUI()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.subviews.last?.isHidden = false
    }
    
    func updateUI(_ name: String!,_ des: String!,_ time: Double,_ photos: NSMutableArray!){
        titleTextField.text = name
        descriptionText.text = des
        photoView.selectedPhoto = photos
        model?.createTime = time
        
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = nil
        title = "预览"
    }

}

extension AddViewController{
    @objc func saveInfo(){
        if model == nil{
            return
        }
        model!.name = titleTextField.text ?? ""
        model!.des = descriptionText.text ?? ""
        let nowDate = Date().timeIntervalSince1970
        model?.createTime = nowDate
        if photoView.selectedPhoto.count > 0{
            for (index, item) in photoView.selectedPhoto.enumerated() {
                ImageFileManager.shared.saveImage(currentImage: item as! UIImage, persent: 1.0, imageName: "Image_" + "\(model?.createTime ?? 0)" + "\(index)")
            }
            model?.imageDataPath = ImageFileManager.shared.fileFullPath("Image_" + "\(model?.createTime ?? 0)" + "\(0)")
        }
        saveSql(model!)
    }
    
    func saveSql(_ model: ImageModel){
        if ImageDBManger.insertOrUpdateTable(model) {
            _ = self.navigationController?.popViewController(animated: true)
        }else {
            let alert = UIAlertController.init(title: "", message: "保存失败", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "确认", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            print("-----------------")
        }
    }
}

extension AddViewController{
    func configUI(){
    //set Up text
        setUPTitleTextField()
        setUpText()
        setUpImageTitleLabel()
        setPhotoView()
        setNavgationBar()
    }
    
    func setNavgationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveInfo))
    }
    
    func setUPTitleTextField() {
        titleTextField.font = kFont_15
        titleTextField.textColor = kColor_5
        titleTextField.layer.masksToBounds = true
        titleTextField.layer.cornerRadius =  5
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = kColor_8.cgColor
        titleTextField.placeholder = "标题。。。"
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(74)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(30)
        }
        
    }
    
    func setUpText() {
        descriptionText.delegate = self
        descriptionText.font = kFont_15
        descriptionText.textColor = kColor_5
        descriptionText.layer.masksToBounds = true
        descriptionText.layer.cornerRadius =  5
        descriptionText.layer.borderWidth = 1
        descriptionText.layer.borderColor = kColor_8.cgColor
        descriptionText.placeHolder = "写点什么吧。。。"
        view.addSubview(descriptionText)
        descriptionText.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
        
    }
    
    func setPhotoView() {
        photoView.backgroundColor = UIColor.red
       view.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.top.equalTo(imageTitleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func setUpImageTitleLabel() {
        imageTitleLabel.text = "用图片记录你的美好时刻。。。"
        imageTitleLabel.font = kFont_15
        imageTitleLabel.textColor = kColor_5
        view.addSubview(imageTitleLabel)
        imageTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionText.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
        }
    }
    
}

extension AddViewController: UITextViewDelegate{
    
}
