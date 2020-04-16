//
//  ViewController.swift
//  CWAlertManager
//
//  Created by 陈旺 on 2020/4/16.
//  Copyright © 2020 chenwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var waitCountLabel: UILabel!
    
    @IBOutlet weak var showCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func runScript(_ sender: Any) {
        
//        func cwpresent(_ controller: UIViewController, targetVC: UIViewController) {
//            if nil != controller.presentedViewController
//            {
//                cwpresent(controller.presentedViewController!, targetVC: targetVC)
//            }
//            else
//            {
//                controller.present(targetVC, animated: true, completion: nil)
//            }
//        }
//
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
//            let alert = UIAlertController.cw_alertOneButton(title: "1", text: "1")
//            cwpresent(self, targetVC: alert)
//            return
//        }
        
        CWAlertManager.shared.popCompletionBlock = { (alert) in
            freshLabel()
        }

        func freshLabel() {
            self.waitCountLabel.text = "等待添加Alert: " + CWAlertManager.shared.waitCount
            self.showCountLabel.text = "当前展示Alert: " + CWAlertManager.shared.showCount
        }

        var index: Int = 0
        for _ in 0..<6 {

            UIAlertController.cw_alertOneButton(title: "提示", text: String(format: "%ld", index)).cw_presentedBy(self, completion: {
                print("添加完成啦...")
                freshLabel()
            })
            index += 1
        }
        
    }
}

