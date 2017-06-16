//
//  MarketAuctionViewController.swift
//  iOSStar
//
//  Created by J-bb on 17/5/17.
//  Copyright © 2017年 YunDian. All rights reserved.
//

import UIKit

class MarketAuctionViewController: MarketBaseViewController {

    var count = 540
    var endTime:Int64 = 0
    var timeLabel:UILabel?
    var headerCell:AuctionHeaderCell?
    
    var statusModel:AuctionStatusModel?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = tableView
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 450))

        tableView.register(FansListHeaderView.self, forHeaderFooterViewReuseIdentifier: "FansListHeaderView")

        requestAuctionSattus()
    }

    func initCountDownBlock() {
        
        guard headerCell != nil else {
            return
        }
        YD_CountDownHelper.shared.marketBuyOrSellListRefresh = { [weak self] (result)in
        }
        
        YD_CountDownHelper.shared.countDownRefresh = { [weak self] (result)in
            guard self != nil  else {
                return
                
            }
            self?.count -= 1
            if self?.count != 0 {
                
                self?.headerCell?.setTimeText(text:YD_CountDownHelper.shared.getTextWithStartTime(closeTime: Int(self!.endTime)))
            } else {
                self?.headerCell?.setTimeText(text: "拍卖未开始")
            }
            
        }
    }
    func refreshSatus() {
        
        guard  statusModel != nil else {
            return
        }
        if statusModel!.status {
            endTime = Int64(Date().timeIntervalSince1970) + statusModel!.remainingTime + YD_CountDownHelper.shared.timeDistance
            initCountDownBlock()
        } else {
           headerCell?.setTimeText(text: "拍卖未开始")
        }

    }
    func requestAuctionSattus() {
        let model = AuctionStatusRequestModel()
        model.symbol = starCode!
        AppAPIHelper.marketAPI().requestAuctionStatus(requestModel: model, complete: { (response) in
            if let model = response as? AuctionStatusModel {
                self.statusModel = model
                self.refreshSatus()
            }
        }, error: errorBlockFunc())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("--------countDownRefresh---------开始----------------")
        refreshSatus()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YD_CountDownHelper.shared.countDownRefresh = nil
        YD_CountDownHelper.shared.marketBuyOrSellListRefresh = nil
        print("--------countDownRefresh---------结束----------------")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MarketAuctionViewController:UITableViewDataSource, UITableViewDelegate, SelectFansDelegate{
    
    func selectAtIndex(index: Int) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FansListHeaderView") as! FansListHeaderView
        headerView.delegate = self
        headerView.settitles(titles: ["买入","卖出"])
        headerView.isShowImage = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 580.5
        }
        return 90
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MarketAuctionCell", for: indexPath) as! MarketAuctionCell
            return cell            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuctionHeaderCell", for: indexPath) as! AuctionHeaderCell
        self.headerCell = cell

        return cell
    }
}
