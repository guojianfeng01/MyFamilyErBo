//
//  SetUpViewController.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/13.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit

class SetUpViewController: ViewController {
    fileprivate lazy var tableview: UITableView! = UITableView.init(frame: view.bounds, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        configUI()
        // Do any additional setup after loading the view.
    }
    func configUI(){
        setupTableView()
    }
   
}

extension SetUpViewController{
    fileprivate func setupTableView(){
        tableview.frame = view.bounds
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        view.addSubview(tableview)
    }
}

extension SetUpViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
