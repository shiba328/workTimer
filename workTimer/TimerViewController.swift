//
//  TimerViweController.swift
//  workTimer
//
//  Created by shiba on 2018/09/16.
//  Copyright © 2018年 shiba. All rights reserved.
//

import UIKit
import Foundation
class TimerViewController: UIViewController{
    var navBar: UINavigationBar!
    var headview: UIView!
    var countLabel: UILabel!
    var headBar: UINavigationBar!
    var headBtn: UIButton!
    var headDram: UIButton!
    var headInpt: UITextField!
    var Timer = Foundation.Timer()
    var count: Int = 0 {
        //カウンタが更新されるたびにセットする
        didSet{
            let hour = String(format: "%02i", count / 3600)
            let min = String(format: "%02i", count / 60 % 60)
            let sec = String(format: "%02i", count % 60)
            countLabel.text = "\(hour):\(min):\(sec)"
        }
    }
    
    override func viewDidLoad() {
        configNavbar()
        configHead()
        configCounter()
        configHeadBtn()
        configHeadDram()
        configHeagInput()
    }
    func configHeagInput(){
        headInpt = UITextField()
        headInpt.frame = CGRect(x:0, y:self.headview.bounds.height - 50.5, width:self.headview.bounds.width - 200, height:50)
        headInpt.placeholder = "作業内容を入力…"
        headInpt.backgroundColor = UIColor.white
        self.headview.addSubview(headInpt)
    }
    func configHeadDram(){
        headDram = UIButton(type: UIButtonType.system)
        headDram.frame = CGRect(x:self.headview.bounds.width - 199.5, y:self.headview.bounds.height - 50.5, width:100, height:50)
        headDram.backgroundColor = UIColor.white
        headDram.setTitle("Choice", for: .normal)

        headDram.addTarget(self, action: #selector(self.onTapChoice(sender: )), for: .touchUpInside)
        self.headview.addSubview(headDram)
    }
    func configHeadBtn(){
        headBtn = UIButton(type: UIButtonType.system)
        headBtn.frame = CGRect(x:self.headview.bounds.width - 100, y:self.headview.bounds.height - 50.5, width:100, height:50)
        headBtn.tag = 1
        headBtn.backgroundColor = UIColor.orange
        headBtn.setTitle("START", for: .normal)
        headBtn.setTitleColor(UIColor.white, for: .normal)
        headBtn.addTarget(self, action: #selector(self.onTapStart(sender: )), for: .touchUpInside)
        self.headview.addSubview(headBtn)
    }
    func configHead(){
        headview = UIView()
        headview.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height/3)
        headview.backgroundColor = UIColor.black
        self.view.addSubview(headview)
    }
    func configCounter(){
        countLabel = UILabel()
        countLabel.text = "00:00:00"
        countLabel.textColor = UIColor.white
        countLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:100)
        countLabel.font = UIFont(name: "HelveticaNeue-UltraLight",size: CGFloat(70))
        countLabel.textAlignment = .center
        countLabel.sizeToFit()
        countLabel.center = self.headview.center
        self.headview.addSubview(countLabel)
    }
    
    func configNavbar(){
        navBar = UINavigationBar()
        navBar.frame = CGRect(x:0, y:self.view.bounds.height - 40, width:self.view.bounds.width, height:40)
        let navigationItem = UINavigationItem()
        let play = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: self, action: #selector(rigthBarBtnClicked))
        navigationItem.rightBarButtonItems = [play]
        navBar.pushItem(navigationItem, animated: true)
        self.view.addSubview(navBar)
    }

    //右側のボタンが押されたら呼ばれる
    @objc internal func rigthBarBtnClicked(sender: UIButton){
        print("roghtBarBtnClicked")
    }
    @objc func onTapStart(sender: UIButton){
        switch sender.tag
        {
        case 1:
            sender.setTitle("STOP", for: .normal)
            sender.backgroundColor = UIColor.darkGray
            sender.tag = 2
            startTimer()
            break
        case 2:
            sender.setTitle("START", for: .normal)
            sender.backgroundColor = UIColor.orange
            sender.tag = 1
            Timer.invalidate()
            stopTimer()
            break
        case 3:
            break
        default: print("Other...")
        }
    }
    @objc func onTapChoice(sender: UIButton){
        print("sss")
    }
    func startTimer(){
        Timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo:nil, repeats:true)
        
    }
    @objc func UpdateTimer(){
        count = count + 1
    }
    func stopTimer(){
        print(self.headInpt.text, count)
    }
}

