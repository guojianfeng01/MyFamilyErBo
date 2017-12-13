//
//  PhotoView.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/15.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit
import TZImagePickerController

class PhotoView: UIView {
    open var maxCountTF: Int = 9
    open var columnNumberTF: Int = 3
    open var allowPickingOriginalPhotoSwitch: Bool = true
    
    open var allowPickingVideoSwitch: Bool = false
    open var allowPickingImageSwitch: Bool = true
    open var selectedPhoto: NSMutableArray!{
        didSet{
            selectedAssets = NSMutableArray.init(array: selectedPhoto)
            collectionView.reloadData()
        }
    }
    
    fileprivate let margin: CGFloat = 4.0
    fileprivate var itemWH: CGFloat = 0.0
    fileprivate var selectedAssets: NSMutableArray!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedPhoto = NSMutableArray()
        selectedAssets = NSMutableArray()
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = kColor_9
        collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        self.addSubview(collectionView)
        collectionView.register(TZPhotoCell.self, forCellWithReuseIdentifier: "TZPhotoCellID")
    }
    
    fileprivate lazy var collectionView: UICollectionView! = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
    fileprivate lazy var flowLayout: LxGridViewFlowLayout! = LxGridViewFlowLayout.init()
    fileprivate lazy var imagePickerVc: UIImagePickerController! = {
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        let tzBarItem = UIBarButtonItem.aw_appearanceWhenContained(in: TZImagePickerController.self)
        let barItem = UIBarButtonItem.aw_appearanceWhenContained(in: UIImagePickerController.self)
        let titleTextAttributes = tzBarItem?.titleTextAttributes(for: .normal)
        
        let stringKey = NSAttributedStringKey.init(rawValue: (titleTextAttributes?.keys.first)!)
        barItem?.setTitleTextAttributes([stringKey:titleTextAttributes!.values.first!], for: .normal)
        return imagePickerVc
    }()
    
    
}

//MARK: action
extension PhotoView{
    @objc  func deleteBtnClick(_ sender: UIButton){
        print("\(sender.tag)")
    }
}

//MARK: UIConfig
extension PhotoView{
    override func layoutSubviews() {
        super.layoutSubviews()
        itemWH = (self.frame.size.width - 2 * margin - 4)/3 - margin
        flowLayout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func controller(view:UIView)->UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.next, nextResponder.isKind(of: UIViewController.self){
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
}

//MARK: ImagePicker
extension PhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func pushTZImagePickerController(){
        if self.maxCountTF <= 0{
            return
        }
        let imageController = TZImagePickerController.init(maxImagesCount: maxCountTF, columnNumber: columnNumberTF, delegate: self, pushPhotoPickerVc: true)
        
        imageController?.isSelectOriginalPhoto = true
        if (self.maxCountTF > 1) {
            // 1.设置目前已经选中的图片数组
            imageController?.selectedAssets = selectedAssets; // 目前已经选中的图片数组
        }
        imageController?.allowTakePicture = true
        imageController?.sortAscendingByModificationDate = true
        UIApplication.shared.keyWindow?.subviews.last?.isHidden = true
        controller(view: self)?.present(imageController!, animated: true, completion: nil)
    }
    
    func photoShowBig(_ indexPath: IndexPath){
        let imagePickerController = TZImagePickerController.init(selectedAssets: selectedAssets, selectedPhotos: selectedPhoto, index: indexPath.row)
        imagePickerController?.maxImagesCount = maxCountTF
        imagePickerController?.allowPickingGif = false
        imagePickerController?.allowPickingOriginalPhoto = true
        imagePickerController?.allowPickingMultipleVideo = false
        imagePickerController?.isSelectOriginalPhoto = false
        imagePickerController?.didFinishPickingPhotosHandle = {(_ photos: [UIImage]?, _ assets: [Any]?, _ isSelectOriginalPhoto: Bool) -> Void in
            self.selectedPhoto = NSMutableArray.init(array: photos!)
            self.selectedAssets = NSMutableArray.init(array: assets!)
            self.collectionView.reloadData()
            self.collectionView.contentSize = CGSize.init(width: 0, height: CGFloat(((self.selectedPhoto.count + 2) / 3 )) * (self.margin + self.itemWH))
            }
        UIApplication.shared.keyWindow?.subviews.last?.isHidden = true
        controller(view: self)?.present(imagePickerController!, animated: true, completion: nil)
    }
}

//MARK: LxGridViewDataSource
extension PhotoView: LxGridViewDataSource{
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.item < selectedPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt sourceIndexPath: IndexPath!, canMoveTo destinationIndexPath: IndexPath!) -> Bool {
        return (sourceIndexPath.item < selectedPhoto.count && destinationIndexPath.item < selectedPhoto.count)
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt sourceIndexPath: IndexPath!, didMoveTo destinationIndexPath: IndexPath!) {
        let image: UIImage? = selectedPhoto[sourceIndexPath.item] as? UIImage
        selectedPhoto.removeObject(at: sourceIndexPath.item)
        selectedPhoto.insert(image!, at: destinationIndexPath.item)
        let asset = selectedAssets[sourceIndexPath.item]
        selectedAssets.removeObject(at: sourceIndexPath.item)
        selectedAssets.insert(asset, at: destinationIndexPath.item)
        collectionView.reloadData()
    }
}


//MARK: UICollectionViewConfig
extension PhotoView: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhoto.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TZPhotoCellID", for: indexPath) as! TZPhotoCell
        cell.videoImageView.isHidden = true
        if indexPath.row == selectedPhoto.count {
            cell.imageView.image =  #imageLiteral(resourceName: "AlbumAddBtn")
            cell.deleteBtn.isHidden = true
            cell.gifLable.isHidden = true
        } else {
            cell.imageView.image = selectedPhoto[indexPath.row] as? UIImage
            cell.asset = selectedAssets[indexPath.row];
            cell.deleteBtn.isHidden = false
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == selectedPhoto.count {
            pushTZImagePickerController()
        } else {
           photoShowBig(indexPath)
        }
    }
}

extension PhotoView: TZImagePickerControllerDelegate{
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        self.selectedPhoto = NSMutableArray.init(array: photos)
        self.selectedAssets = NSMutableArray.init(array: assets)
        self.collectionView.reloadData()
    }
}
