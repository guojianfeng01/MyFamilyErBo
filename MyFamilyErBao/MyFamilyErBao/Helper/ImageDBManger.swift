//
//  ImageDBManger.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/21.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit

class ImageDBManger: NSObject {
    static let USER_TABLENAME = "USER_TABLENAME"//表名
    static let USER_SQL_VERSION = "USER_SQL_VERSION"//本地清除数据库版本名
    static let USER_SQL_VERSION_CODE = "1.0.0"//上个版本需要清空数据库的版本号
    static let USER_SQL_UPDATE = "USER_SQL_UPDATE"//升级本地数据库版本名
    static let USER_SQL_UPDATE_CODE = "1.0.1"//上个版本需要改变数据库的表的字段
    static let USER_SQL_TYPE = true //表中是否含有特殊类型（如Data类型）
    ///创建数据库
    @discardableResult  static func createTable() -> Bool {
        let defaults = UserDefaults.standard
        let version = defaults.value(forKey: USER_SQL_VERSION)
        let update = defaults.value(forKey: USER_SQL_UPDATE)
        if let version = version ,(version as! String) == USER_SQL_VERSION_CODE {
            if let update = update as? String{
                if  let intUpdate = Int(update.replacingOccurrences(of: ".", with: "")) {
                    if intUpdate > 100 {
                        
                        if let _ = DBManager.shared.querySql(sql: "select id from \(USER_TABLENAME)"){
                            
                        } else {
                            DBManager.shared.execSql(sql: "ALTER TABLE \(USER_TABLENAME)  ADD COLUMN  \("id") INTEGER DEFAULT 0 IF NOT EXISTS")
                            
                        }
                        
                        
                    }
                }
                
            }
            
            defaults.setValue(USER_SQL_UPDATE_CODE, forKey: USER_SQL_UPDATE)
        }else {
            DBManager.shared.dropTable(tableName: USER_TABLENAME)
            defaults.setValue(USER_SQL_VERSION_CODE, forKey: USER_SQL_VERSION)
        }
        
        let result = DBManager.shared.createTable(tableName: USER_TABLENAME, andColoumName: ["auto_index":"INTEGER PRIMARY KEY AUTOINCREMENT",
                                                                                               "name":SQLITE_TEXT_TYPE,
                                                                                               "des":SQLITE_INT_TYPE,
                                                                                               "imageDataPath":SQLITE_TEXT_TYPE,
                                                                                               "createTime":SQLITE_DOUBLE_TYPE,
                                                                                               "id": "INTEGER Default 0"
            ], andAddIndex: ["des","createTime"])
        return result
    }
    
    ///插入一条数据
    @discardableResult static func insertOrUpdateTable(_ model:ImageModel) -> Bool {
        var dic: [String:AnyObject] = Dictionary()
        var whereParam: [String:AnyObject] = Dictionary()
        dic.updateValue(model.name as AnyObject, forKey: "name")
        dic.updateValue(model.des as AnyObject, forKey: "des")
        
        if  model.imageDataPath.count > 0 {
            dic.updateValue(model.imageDataPath as AnyObject, forKey: "imageDataPath")
        }
        
        dic.updateValue(model.createTime as AnyObject, forKey: "createTime")
        whereParam.updateValue(model.createTime as AnyObject, forKey: "createTime")
        if model.id > 0 {
            dic.updateValue(model.id as AnyObject, forKey: "id")
        }
        
        
        var result = false
        if !USER_SQL_TYPE {
            if ImageDBManger.getOneDataWithId(model.id)  {
                result = DBManager.shared.updateTable(tableName: USER_TABLENAME, andColoumValue: dic, andWhereParam: whereParam)
                
            }else{
                result = DBManager.shared.insertTable(tableName: USER_TABLENAME, andColoumValue: dic)
            }
            
            
        }else{
            if ImageDBManger.getOneDataWithId(model.id){
                result = DBManager.shared.updateTableSql(tableName: USER_TABLENAME, andColoumValue: dic, andWhereParam: whereParam)
                
            }else {
                model.id = Int(arc4random())
                while true{
                    if ImageDBManger.getOneDataWithId(model.id){
                        model.id = Int(arc4random())
                    }else{
                        break
                    }
                }
                dic.updateValue(model.id as AnyObject, forKey: "id")
                result =  DBManager.shared.insertTableSql(tableName: USER_TABLENAME, andColoumValue: dic)
                
            }
        }
        
        return result
    }
    
    
    
    ///获取一条数据
    @discardableResult static func getOneData(_ createTime:Double) -> Bool {
        
        let sql = "select * from \(USER_TABLENAME) where createTime like \(createTime)"
        if let arr = ImageDBManger.getAllDataUseSql(sql: sql) ,  arr.count > 0 {
            return true
        }
        return false
    }
    
    ///获取一条数据
    @discardableResult static func getOneDataWithId(_ id:Int) -> Bool {
        
        let sql = "select * from \(USER_TABLENAME) where id == \(id)"
        if let arr = ImageDBManger.getAllDataUseSql(sql: sql) ,  arr.count > 0 {
            return true
        }
        return false
    }
    ///查询数据库
    @discardableResult static func getAllDataUseSql(sql: String) -> [ImageModel]? {
        if let arr = DBManager.shared.querySql(sql: sql) ,  arr.count > 0 {
            var arrModel: [ImageModel] = []
            arr.forEach({ (dic) in
                if dic.count > 0 {
                    let model = ImageModel()
                    if let value = dic["name"] as? String{
                        model.name = value
                    }
                    if let value = dic["des"] as? String{
                        model.des = value
                    }
                    if let value = dic["imageDataPath"] as? String{
                        model.imageDataPath = value
                    }
                    if let value = dic["createTime"] as? Double{
                        model.createTime = value
                    }
                    if let value = dic["id"] as? Int32{
                        model.id = Int(value)
                    }
                    arrModel.append(model)
                }
                
            })
            return arrModel
        }
        return nil
    }
    ///删除数据
    
    @discardableResult static func delectData(_ model:ImageModel) ->Bool {
        
        var whereParam: [String:AnyObject] = Dictionary()
        whereParam.updateValue(model.name.searchSql() as AnyObject, forKey: "name")
        //        whereParam.updateValue(model.imageData as AnyObject, forKey: "imageData")
        var result = false
        if !USER_SQL_TYPE {
            result = DBManager.shared.deleteTable(tableName: USER_TABLENAME, andWhereParam: whereParam)
        }else {
            result = DBManager.shared.deleteTableSql(tableName: USER_TABLENAME, andWhereParam: whereParam)
        }
        
        return result
        
    }
}
