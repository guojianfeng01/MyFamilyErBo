//
//  HomeViewController.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/10.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {
    fileprivate lazy var tableView = UITableView(frame: self.view.bounds, style: .plain)
    fileprivate var dataSource: [ImageModel]! = [ImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.backgroundColor =  kColor_9
        configUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadSqlData("select * from \(ImageDBManger.USER_TABLENAME)")
    }
    
    func testGCD() {
        
    }
    
    func configUI() {
        mainMenu()
        configTableView()
    }
}

//UI设置菜单
extension HomeViewController{
    func mainMenu() {
        let menuItemImage = UIImage(named: "tableview_loading")!
        let menuItemHighlitedImage = UIImage(named: "tableview_loading")!
        let mineImage = UIImage(named: "TabBar_SetUp_23x23_")!
        let addImage = UIImage(named: "TabBar_add_23x23_")!
        let homeImage = UIImage(named: "TabBar_home_23x23_")!
        
        let mineMenuItem = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: mineImage)
        
        let addMenuItem = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: addImage)
        
        let homeMenuItem = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: homeImage)
        
        let items = [mineMenuItem, addMenuItem, homeMenuItem]
        
        let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
                                     highlightedImage: UIImage(named: "bg-addbutton-highlighted"),
                                     contentImage: UIImage(named: "icon-plus"),
                                     highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu.delegate = self
        menu.startPoint     = CGPoint(x: kScreenWidth - 20, y: kScreenHeight - 20.0)
        menu.menuWholeAngle = .pi / 2
        menu.rotateAngle = -(.pi / 2)
        menu.timeOffset     = 0.0
        menu.farRadius      = 110.0
        menu.nearRadius     = 90.0
        menu.endRadius      = 100.0
        menu.animationDuration = 0.5
        UIApplication.shared.keyWindow?.addSubview(menu)
    }
    
    func configTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier:identifyId )
    }
    
    func showEmptyView(){
        MNEmptyViewFactory.emptyMainView(tableView) {
            let vc = AddViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func reloadSqlData(_ string: String){
        
        dataSource =
            ImageDBManger.getAllDataUseSql(sql: string)
        if let dataSource = dataSource{
            if dataSource.count > 0 {
                tableView.reloadData()
            }else{
                showEmptyView()
            }
        }else{
            showEmptyView()
        }
    }
    
    static func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataSource == nil ?  0 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifyId) as! HomeTableViewCell
        let model: ImageModel = dataSource[indexPath.row]
        let imageData = ImageFileManager.shared.getImage(ImageFileManager.shared.filePath() + "Image_" + "\(model.createTime)" + "\(0)")
        cell.updateUI(model.name, model.des, HomeViewController.timeStampToString(timeStamp: String(model.createTime)), imageData == nil ? UIImage.init(named: "placeHolder") : imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddViewController()
        let model = dataSource[indexPath.row]
        let images: NSMutableArray! = NSMutableArray()
        
        for item in 0..<10000 {
            if let image = ImageFileManager.shared.getImage(ImageFileManager.shared.filePath() + "Image_" + "\(model.createTime)" + "\(item)"){
                images.add(image)
            }else{
                break
            }
        }
        
        vc.updateUI(model,images)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: PathMenuDelegate{
    func didSelect(on menu: PathMenu, index: Int) {
        switch index {
        case 0:
            for vc in (self.navigationController?.childViewControllers)!{
                if vc.isMember(of: SetUpViewController.self){
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
            let vc = SetUpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            for vc in (self.navigationController?.childViewControllers)!{
                if vc.isMember(of: AddViewController.self){
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
            let vc = AddViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            for vc in (self.navigationController?.childViewControllers)!{
                if vc.isMember(of: HomeViewController.self){
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    func willStartAnimationOpen(on menu: PathMenu) {
        print("Menu will open!")
    }
    
    func willStartAnimationClose(on menu: PathMenu) {
        print("Menu will close!")
    }
    
    func didFinishAnimationOpen(on menu: PathMenu) {
        print("Menu was open!")
    }
    
    func didFinishAnimationClose(on menu: PathMenu) {
        print("Menu was closed!")
    }
}
