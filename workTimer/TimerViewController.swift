//
//  TimerViweController.swift
//  workTimer
//
//  Created by shiba on 2018/09/16.
//  Copyright © 2018年 shiba. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class TimerViewController: UIViewController{
    var navBar: UINavigationBar!
    var headview: UIView!
    var countLabel: UILabel!
    var headBar: UINavigationBar!
    var headBtn: UIButton!
    var headDram: UIButton!
    var headInpt: UITextField!
    var scrollView: UIScrollView!
    var tableView: UITableView!
    var Timer = Foundation.Timer()
    //
    var ref: DatabaseReference!
    var snap: DataSnapshot!
    var items: [[String : Any]] = []
    var uid: String!
    
    
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
        self.ref = Database.database().reference()
        //ユーザーID
        let user = Auth.auth().currentUser
        self.uid = user?.uid
        configNavbar()
        configHead()
        configCounter()
        configHeadBtn()
        configHeadDram()
        configHeagInput()
        configOverscroll()
        configTableView()
        getDatebase()
    }
    //firebaseのデータ取得
    func getDatebase(){
        //.valueはFIRDataEventTypeドキュメント参考：データに何らかの変化があったとき取得
        ref.child("users/\(self.uid!)/timer").observe(.value, with: { (snapshot) in
            //書く投稿の子オブジェクトを全部取得
            if snapshot.children.allObjects is [DataSnapshot] {
                //snapshotを保存
                self.snap = snapshot
                //そのsnapshotをテーブルに送る
                self.reload(snap: self.snap)
            }
        })
    }
    //firebaseのデータ表示
    func reload(snap: DataSnapshot){
        //snapshotが存在したら
        if snap.exists(){
            //Itemsの中身全消し
            items.removeAll()
            //snapの子毎に回す
            for itemSnapShot in snap.children {
                let item = itemSnapShot as! DataSnapshot
                let dict = item.value as? [String:Any]
                self.items.append(dict!)
            }
//            tableView.reloadData()
        }
    }
    func configTableView(){
        tableView = UITableView()
        
        tableView.frame = CGRect(x:0, y:0, width:self.scrollView.bounds.width, height:100)
        self.scrollView.addSubview(tableView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func configOverscroll(){
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0 ,y:self.headview.bounds.height, width:self.view.bounds.width, height:self.view.bounds.height-self.headview.bounds.height-40)
        scrollView.backgroundColor = UIColor.lightGray
        self.headview.addSubview(scrollView)
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
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.moveStoryboard(name: "Main")
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
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
            let body: String = self.headInpt.text!
            let time: Int = self.count
            let pid: Int = 1
            if self.count > 1 {
                stopTimer(body: body, time: time, pid: pid)
            }
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
    func stopTimer(body: String,time: Int,pid: Int){
        let data = [
            "body": body,
            "time": time,
            "pid": pid
            ] as [String : Any]
        ref.child("users/\(self.uid!)/timer").childByAutoId().setValue(data)
        self.count = 0
        self.headInpt.text = ""
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ユーザがキーボード以外の場所をタップすると、キーボードを閉じる
        self.view.endEditing(true)
    }

}

