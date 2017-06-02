//
//  UserApi.swift
//  iOSStar
//
//  Created by sum on 2017/5/8.
//  Copyright © 2017年 YunDian. All rights reserved.
//

import UIKit

protocol UserApi {
    
      //获取好友列表
       func starmaillist(status: Int32, pos: Int32, count: Int32, complete: CompleteBlock?, error: ErrorBlock?)
      //发送时间少一秒
      func reducetime(phone: String, starcode: String, complete: CompleteBlock?, error: ErrorBlock?)
      //预约的明细
      func getorderstars(phone: String, starcode: String, complete: CompleteBlock?, error: ErrorBlock?)
     // 微信支付
      func weixinpay(title:String,  price:Double, complete: CompleteBlock?, error: ErrorBlock?)
     // 我的资产接口
     func accountMoney(complete: CompleteBlock?, error: ErrorBlock?)
     // 资金明细列表
     func creditlist(status: Int32, pos: Int32, count: Int32, complete: CompleteBlock?, error: ErrorBlock?)
    
    // 重置交易密码
    func ResetPassWd(timestamp : Int64,vCode : String,vToken : String,pwd: String,type : Int, phone :String, complete: CompleteBlock?, error: ErrorBlock?)
     // 实名认证
     func authentication(realname: String, id_card: String, complete: CompleteBlock?, error: ErrorBlock?)
    // 获取实名认证信息
     func getauthentication( complete: CompleteBlock?, error: ErrorBlock?)
     // 获取用户信息
     func getauserinfo( complete: CompleteBlock?, error: ErrorBlock?)
    // tokenLogin token登录
     func tokenLogin( complete: CompleteBlock?, error: ErrorBlock?)
}
