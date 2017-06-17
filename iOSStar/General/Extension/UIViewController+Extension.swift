//
//  UIViewController+Extension.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
import RealmSwift
//import XCGLogger
import SVProgressHUD
extension UIViewController {
    
    class func storyboardInit(identifier:String, storyboardName:String) -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
    func errorBlockFunc()->ErrorBlock {
        return { [weak self] (error) in
            //            XCGLogger.error("\(error) \(self)")
            self?.didRequestError(error)
        }
    }
    func LoginSuccess(){
        
    }
    
    
    func didRequestError(_ error:NSError) {
        SVProgressHUD.showErrorMessage(ErrorMessage: error.localizedDescription, ForDuration: 1.5, completion: nil)
    }
    
    func showErrorWithStatus(_ status: String!) {
        SVProgressHUD.showErrorMessage(ErrorMessage: status, ForDuration: 1.5, completion: nil)
    }
    
    func showWithStatus(_ status: String!) {
        SVProgressHUD.show(withStatus: status)
    }
    //检查是否已登录
    func checkLogin() -> Bool {
        
        if UserDefaults.standard.object(forKey: "phone") as? String == nil {
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            controller?.modalPresentationStyle = .custom
            controller?.modalTransitionStyle = .crossDissolve
            present(controller!, animated: true, completion: nil)
            
            return false
        }else{
            return true
        }
    }
      //登录网易云信
    func doYunxin(complete: CompleteBlock?){
        
        if UserDefaults.standard.object(forKey: "phone") as? String != nil{
            AppAPIHelper.login().registWYIM(phone: (UserDefaults.standard.object(forKey: "phone") as? String)!, token:(UserDefaults.standard.object(forKey: "phone") as? String)!, complete: { (result) in
                
                let datadic = result as? Dictionary<String,String>
                if let _ = datadic {
                    NIMSDK.shared().loginManager.login((UserDefaults.standard.object(forKey: "phone") as? String)!, token: (datadic?["token_value"])!, completion: { (error) in
                        if (error != nil){
                        }
                        complete?(true as AnyObject)
                        
                    })
                    
                    UserDefaults.standard.set((datadic?["token_value"])!, forKey: "tokenvalue")
                    UserDefaults.standard.synchronize()
                    
                    
                }
                
            }) { (error) in
                
            }
        }
    }
    //退出登录
    func userLogout() {


        if let phoneString = UserDefaults.standard.object(forKey: "phone") as? String {
            UserDefaults.standard.set(phoneString, forKey: "lastLogin")
        }
        UserDefaults.standard.removeObject(forKey:"phone")
        UserDefaults.standard.removeObject(forKey: "token")
        tabBarController?.selectedIndex = 0
    }
    
    //检查text是否为空
    func checkTextFieldEmpty(_ array:[UITextField]) -> Bool {
        for  textField in array {
            if  textField.text == ""  {
                SVProgressHUD.showErrorMessage(ErrorMessage: textField.placeholder!, ForDuration: 2.0, completion: {
                });
                return false
            }
        }
        return true
    }
    //关闭模态视图控制器
    func dismissController() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    //打电话
    func didActionTel(_ telPhone:String) {
        let alert = UIAlertController.init(title: "呼叫", message: telPhone, preferredStyle: .alert)
        let ensure = UIAlertAction.init(title: "确定", style: .default, handler: { (action: UIAlertAction) in
            UIApplication.shared.openURL(URL(string: "tel://\(telPhone)")!)
        })
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action: UIAlertAction) in
            
        })
        alert.addAction(ensure)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    //导航栏透明
    func translucent(clear: Bool) {
        
        //     let navImageName = clear ? "nav_clear" : "nav_color"
        //        let navImageName = "nav_bg"
        //        navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: navImageName), for: .any, barMetrics: .default)
        
        navigationController?.navigationBar.isTranslucent = clear;
        
    }
    
    //MARK: -- 隐藏tabBar导航栏
    func hideTabBarWithAnimationDuration() {
        let tabBar = self.tabBarController?.tabBar
        let parent = tabBar?.superview
        let content = parent?.subviews[0]
        let window = parent?.superview
        if window != nil {
            var tabFrame = tabBar?.frame
            tabFrame?.origin.y = (window?.bounds)!.maxY
            tabBar?.frame = tabFrame!
            content?.frame = (window?.bounds)!
        }
        
    }
    func setCustomTitle(title:String) {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.text = title
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(hexString: AppConst.Color.main)
        navigationItem.titleView = label
        
    }
    func showTabBarWithAnimationDuration() {
        let tabBar = self.tabBarController?.tabBar
        let parent = tabBar?.superview
        let content = parent?.subviews[0]
        let window = parent?.superview
        if window != nil {
            var tabFrame = tabBar?.frame
            tabFrame?.origin.y = (window?.bounds)!.maxY - ((tabBar?.frame)?.height)!
            tabBar?.frame = tabFrame!
            
            var contentFrame = content?.frame
            contentFrame?.size.height -= (tabFrame?.size.height)!
        }
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    //判断是否使命认证
    func checkVaildName(complete: CompleteBlock?){
        
//        if UserDefaults.standard.object(forKey: "phone") as? String != nil{
//            AppAPIHelper.login().registWYIM(phone: (UserDefaults.standard.object(forKey: "phone") as? String)!, token:(UserDefaults.standard.object(forKey: "phone") as? String)!, complete: { (result) in
//                
//                let datadic = result as? Dictionary<String,String>
//                
//                if let _ = datadic {
//                    
//                    NIMSDK.shared().loginManager.login((UserDefaults.standard.object(forKey: "phone") as? String)!, token: (datadic?["token_value"])!, completion: { (error) in
//                        if (error != nil){
//                            
//                        }
//                        complete?(true as AnyObject)
//                        //                        self.LoginSuccess()
//                        
//                    })
//                    UserDefaults.standard.set((datadic?["token_value"])!, forKey: "tokenvalue")
//                    UserDefaults.standard.synchronize()
//                    
//                    
//                }
//                
//            }) { (error) in
//                
//            }
//        }
    }
    func getUserrealmInfo(complete: CompleteBlock?){
    
        AppAPIHelper.user().getauthentication(complete: { (result) in
            complete?(result as AnyObject)
        }) { (result) in
            
        }
    }
    
    
    func getUserInfo(complete: CompleteBlock?){
        
         if UserDefaults.standard.object(forKey: "phone") as? String != nil{
            AppAPIHelper.user().getauserinfo(complete: { (result) in
                complete?(result as AnyObject)
            }) { (error) in
                
                if let nav : UINavigationController = self.tabBarController?.selectedViewController as? UINavigationController{
                    if nav.viewControllers.count > 0{
                        self.userLogout()
                        _ = self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                }
                
                
               
            }
        }
    }
    //获取明星姓名
    func getStartName(startCode:String,complete: CompleteBlock?){
        
        let realm = try! Realm()
        let filterStr = "code = \(startCode)"
        let user = realm.objects(StartModel.self).filter(filterStr).first
        if user != nil{
             complete?(user as AnyObject)
        }else{
            complete?(nil)
        }

    
    }
 
}
