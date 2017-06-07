//
//  GetOrderStarsVC.swift
//  iOSStar
//
//  Created by sum on 2017/5/9.
//  Copyright © 2017年 YunDian. All rights reserved.
//

import UIKit
import MJRefresh

class GetOrderStarsVC: BaseCustomPageListTableViewController,OEZTableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我预约的明星"
    
       
    }
    override func didRequest(_ pageIndex: Int) {
        
        AppAPIHelper.user().starmaillist(status: 1, pos: Int32((pageIndex - 1) * 10), count: 10, complete: { (result) in
            let Model : StarListModel = result as! StarListModel
            self.didRequestComplete( Model.depositsinfo as AnyObject)
        }) { (error ) in
            self.didRequestComplete(nil)
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //StarInfoModel
        let model = dataSource?[indexPath.row] as! StarInfoModel
        
        let session = NIMSession(model.faccid, type: .P2P)
        let vc = NTESSessionViewController(session: session)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
  
    
    func tableView(_ tableView: UITableView!, rowAt indexPath: IndexPath!, didAction action: Int, data: Any!) {
        
        if action == 3 {
            let starInfoModel = data as! StarInfoModel
            let session = NIMSession(starInfoModel.faccid, type: .P2P)
            let vc = NTESSessionViewController(session: session)
            self.navigationController?.pushViewController(vc!, animated: true)
//            print("点击了聊一聊按钮?")
        }
    }
    
    // MARK: - Table view data source

    
  



}
