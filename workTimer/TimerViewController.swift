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

class TimerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    //

    var ref: DatabaseReference!
    var projectSnap: DataSnapshot!
    var timerSnap: DataSnapshot!
    var timerItems: [[String : Any]] = []
    var projectItems: [[String : Any]] = []
    var uid: String!
    var Timer = Foundation.Timer()

    @IBOutlet weak var headInp: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var counterLabel: UILabel!

    @IBAction func choice(_ sender: Any) {
    }
    @IBAction func ToggleBtn(_ sender: UIButton) {
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
            break
        case 3:
            break
        default: print("Other...")
        }
    }
    @objc func UpdateTimer(){
        count = count + 1
    }
    var count: Int = 0 {
        didSet{
            let hour = String(format: "%02i", count / 3600)
            let min = String(format: "%02i", count / 60 % 60)
            let sec = String(format: "%02i", count % 60)
            counterLabel.text = "\(hour):\(min):\(sec)"
        }
    }
    
    override func viewDidLoad() {
        self.ref = Database.database().reference()
        let user = Auth.auth().currentUser
        self.uid = user?.uid
        getDatebase()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func startTimer(){
        Timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo:nil, repeats:true)
    }
    func getDatebase(){
        ref.child("users/\(self.uid!)/project").observe(.value, with: { (snapshot) in
            if snapshot.children.allObjects is [DataSnapshot] {
                self.projectSnap = snapshot
                self.projectReload(snap: snapshot)
            }
        })
    
        ref.child("users/\(self.uid!)/timer").observe(.value, with: { (snapshot) in
            if snapshot.children.allObjects is [DataSnapshot] {
                self.timerSnap = snapshot
                self.timerReload(snap: snapshot)
            }
        })
    }
    func projectReload(snap: DataSnapshot){
        //snapshotが存在したら
        if snap.exists(){
            //Itemsの中身全消し
            projectItems.removeAll()
            //snapの子毎に回す
            for itemSnapShot in snap.children {
                let item = itemSnapShot as! DataSnapshot
                let dict = item.value as? [String:Any]
                self.projectItems.append(dict!)
            }
        }
    }
    func timerReload(snap: DataSnapshot){
        //snapshotが存在したら
        if snap.exists(){
            //Itemsの中身全消し
            timerItems.removeAll()
            //snapの子毎に回す
            for itemSnapShot in snap.children {
                let item = itemSnapShot as! DataSnapshot
                let dict = item.value as? [String:Any]
                self.timerItems.append(dict!)
            }
        }
        tableView.reloadData()
    }

    
    //Table Viewのセルの数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.timerItems.count == 0{
            return 1
        }else{
            return self.timerItems.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellをつくる
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        //中身ない場合は一旦データなしを追加
        let body = cell.viewWithTag(1) as! UILabel
        let start = cell.viewWithTag(2) as! UIButton
        let time = cell.viewWithTag(3) as! UIButton
        let proj = cell.viewWithTag(4) as! UIButton
        if self.timerItems.count == 0{
            body.text = "データなし"
            start.setTitle("", for: .normal)
            time.setTitle("", for: .normal)
            proj.setTitle("", for: .normal)
            return cell
        }else{
            let projStr = self.timerItems[indexPath.row]["pid"] as? String
            body.text = self.timerItems[indexPath.row]["body"] as? String
            let date = self.timerItems[indexPath.row]["startDate"] as? String
            let int = self.timerItems[indexPath.row]["time"] as? Int
            let hour = String(format: "%02i", int! / 3600)
            let min = String(format: "%02i", int! / 60 % 60)
            let sec = String(format: "%02i", int! % 60)
            let str = "\(hour):\(min):\(sec)"
        
            start.setTitle(date, for: .normal)
            start.titleLabel?.numberOfLines = 0
            time.setTitle("\(str)" , for: .normal)
            proj.setTitle("\(projStr!)" , for: .normal)
            return cell
        }
    }
}

