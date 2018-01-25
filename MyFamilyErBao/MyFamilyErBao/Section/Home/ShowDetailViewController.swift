//
//  ShowDetailViewController.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/12/26.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit
import JXPhotoBrowser

class ShowDetailViewController: ViewController {
    fileprivate let margin: CGFloat = 4.0
    fileprivate var itemWH: CGFloat = 0.0
    fileprivate lazy var titleTextField = UITextField()
    fileprivate lazy var descriptionText = WGTextView()
    fileprivate lazy var imageView = UIView()
    fileprivate lazy var imageTitleLabel = UILabel()
    fileprivate var photoBrowser: PhotoBrowser!
    fileprivate lazy var collectionView: UICollectionView! = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout! = UICollectionViewFlowLayout.init()
    
    open var showPhotos: NSMutableArray = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "预览"
        automaticallyAdjustsScrollViewInsets = false
        photoBrowser = PhotoBrowser(showByViewController: self, delegate: self)
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.subviews.last?.isHidden = false
    }
    
}

extension ShowDetailViewController: PhotoBrowserDelegate{
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        let cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? TZPhotoCell
        // 取thumbnailImage
        return cell?.imageView.image
    }
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return showPhotos.count
    }
    
   
}

extension ShowDetailViewController{
    func configUI(){
        //set Up text
        setUPTitleTextField()
        setUpText()
        setUpImageTitleLabel()
        setCollectionView()
    }
    
    func setCollectionView() {
        itemWH = (self.view.frame.size.width - 2 * margin - 4)/3 - margin
        flowLayout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = kColor_9
        collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        self.view.addSubview(collectionView)
        collectionView.register(TZPhotoCell.self, forCellWithReuseIdentifier: "TZPhotoCellID")
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
    
    func photoShowBig(_ index: IndexPath) {
        photoBrowser.show(index: index.row)
    }
    
}

//MARK: UICollectionViewConfig
extension ShowDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  showPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TZPhotoCellID", for: indexPath) as! TZPhotoCell
        cell.videoImageView.isHidden = true
        
        cell.imageView.image = showPhotos[indexPath.row] as? UIImage
        cell.deleteBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoShowBig(indexPath)
    }
}
