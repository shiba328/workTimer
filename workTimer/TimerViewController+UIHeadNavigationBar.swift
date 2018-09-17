//
//  TimerViewController+UIHeadNavigationBar.swift
//  workTimer
//
//  Created by shiba on 2018/09/17.
//  Copyright © 2018年 shiba. All rights reserved.
//

import UIKit
import Foundation
import Firebase

extension TimerViewController{
    @IBAction func ToggleBtn(_ sender: UIButton) {
        switch sender.tag
        {
        case 1:
            sender.setTitle("STOP", for: .normal)
            sender.backgroundColor = UIColor.darkGray
            sender.tag = 2
            startTimer()
            let date = Date()
            self.startTime = date.toStringWithCurrentLocale()
            break
        case 2:
            sender.setTitle("START", for: .normal)
            sender.backgroundColor = UIColor.orange
            sender.tag = 1
            Timer.invalidate()
            if self.count > 1 {
                let stop = stopTimer()
            }
            break
        case 3:
            break
        default: print("Other...")
        }
    }
    func startTimer(){
        Timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo:nil, repeats:true)
    }
    @objc func UpdateTimer(){
        count = count + 1
    }
    func stopTimer() -> Bool {
        
        let body: String = self.headInp.text!
        let time: Int = self.count
        let pkey: String!
        if choiceProjrct["key"] == nil{
            pkey = ""
        }else{
            pkey = choiceProjrct["key"] as! String
        }
        let data = [
            "body": body,
            "time": time,
            "pkey": pkey,
            "startDate": self.startTime
            ] as [String : Any]
        ref.child("users/\(self.uid!)/timer").childByAutoId().setValue(data)
        self.count = 0
        self.headInp.text = ""
        return true
    }

}

extension Date {
    
    func toStringWithCurrentLocale() -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
    
}
