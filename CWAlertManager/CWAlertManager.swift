//
//  AppDelegate.swift
//  CWAlertManager
//
//  Created by 陈旺 on 2020/4/16.
//  Copyright © 2020 chenwang. All rights reserved.
//

import UIKit

typealias cw_completion = (()->Void)?

public class CWAlertManager {
    
    static var shared: CWAlertManager = CWAlertManager()
    
    /// 所有展示中的alert栈 (先进后出,后进先出)
    private var alertStack = [UIAlertController]()
    /// 待展示alert队列, (先进先出,后进后出)
    private var waitAlertQueue = [UIAlertController]()
    /// 当前展示中的alert
    private var currentAlert: UIAlertController?
    
    /// 展示栈中的alert数
    var showCount: String {
        return String(self.alertStack.count)
    }
    
    /// 等待队列中的alert数
    var waitCount: String {
        return String(self.waitAlertQueue.count)
    }
    
    /// alert出栈后的回调
    var popCompletionBlock:((UIAlertController)->Void)?
    
    /// 是否正在执行present
    private var isPresenting = false
    /// 是否正在执行dismiss
    private var isDismissing = false
    
    /// alert对应控制器
    private var controlerDic = [UIAlertController : UIViewController]()
    /// alert对应的回调block
    private var completionDic = [UIAlertController : ()->Void]()
    
    private init() {
        
    }
    
    /// 添加并管理新弹框
    func addAlert(_ alert: UIAlertController, _ controller: UIViewController, completion:cw_completion = nil) {
        // 1.记录一下alert对应的controller和回调
        self.controlerDic[alert] = controller
        self.completionDic[alert] = completion ?? {}
        // 2.展示alert
        self.show(alert, completion: completion)
    }
    
    /// 移除弹框管理
    func pop() {
        // 开始移除
        self.dismissTop {
            if let alert = self.alertStack.last
            {
                self.alertStack.removeLast()
                self.controlerDic.removeValue(forKey: alert)
                self.completionDic.removeValue(forKey: alert)
                self.currentAlert = nil
                self.popCompletionBlock?(alert)
            }
            if self.waitAlertQueue.isEmpty == false
            {
                self.showWait()
            }
            else if self.alertStack.isEmpty == false
            {
                self.show(self.alertStack.last!, addToQueue: false,completion: nil)
            }
        }
    }
    
    /// 开始展示弹框
    fileprivate func show(_ alert: UIAlertController,addToQueue: Bool = true, completion:cw_completion) {
        // 1.判断当前是否处于动画中
        guard self.isPresenting == false && self.isDismissing == false else {
            // 1.1处于动画中,添加到等待队列中
            self.waitAlertQueue.append(alert)
            return
        }
        // 2.没有处于动画中, 隐藏顶层当前alert
        self.dismissTop {
            // 3.隐藏完毕, 开始展示最新alert
            self.isPresenting = true
            self.currentAlert = alert
            if addToQueue {self.alertStack.append(alert)}
            self.controlerDic[alert]?.present(alert, animated: true, completion: {
                self.isPresenting = false
                completion?()
                // 当前alert展示完成,去等待队列查看是否有最新的alert
                self.showWait()
            })
        }
    }
    
    /// 隐藏最顶部alert
    fileprivate func dismissTop(completion: cw_completion) {
        guard nil != self.currentAlert else
        {
            // 当前没有展示中的alert, 直接走回调
            completion?()
            return
        }
        // 隐藏当前展示的alert
        self.dismiss(self.currentAlert!, completion: completion)
    }
    
    /// 展示等待队列弹框
    fileprivate func showWait() {
        // 等待队列为空,直接return
        guard self.waitAlertQueue.isEmpty == false else {return}
        // 否则展示第一个
        let alert = self.waitAlertQueue.first!
        let block = self.completionDic[alert]
        self.waitAlertQueue.removeFirst()
        self.show(alert, completion: block!)
    }
    
    /// 隐藏弹框
    fileprivate func dismiss(_ alert: UIAlertController, completion: cw_completion) {
        self.isDismissing = true
        self.controlerDic[alert]?.dismiss(animated: true, completion: {
            self.isDismissing = false
            completion?()
        })
    }
}

extension UIAlertController {
    
    class func cw_alertOneButton(title: String?, text: String?, buttonText: String? = "确定", buttonBlock:(()->Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction.init(title: buttonText, style: .default) { (action) in
            CWAlertManager.shared.pop()
            buttonBlock?()
        }
        alertController.addAction(action)
        return alertController
    }
    
    class func cw_alertTwoButton(title: String?, text: String?, leftButtonText: String? = "确定", rightButtonText: String? = "取消", buttonBlock:((Int)->Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        let left_action = UIAlertAction.init(title: leftButtonText, style: .default) { (action) in
            CWAlertManager.shared.pop()
            buttonBlock?(0)
        }
        let right_action = UIAlertAction.init(title: rightButtonText, style: .cancel) { (action) in
            CWAlertManager.shared.pop()
            buttonBlock?(1)
        }
        alertController.addAction(left_action)
        alertController.addAction(right_action)
        return alertController
    }
    
    func cw_presentedBy(_ controller: UIViewController, completion:(()->Void)? = nil) {
        CWAlertManager.shared.addAlert(self, controller, completion: completion)
    }
}
