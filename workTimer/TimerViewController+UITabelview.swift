//
//  TimerViewController+UITabelview.swift
//  workTimer
//
//  Created by shiba on 2018/09/17.
//  Copyright © 2018年 shiba. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

extension TimerViewController{
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
                var dict = item.value as? [String:Any]
                dict!["key"] = item.key
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
}

extension TimerViewController: UITableViewDelegate{
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
            let key = self.timerItems[indexPath.row]["pkey"] as? String
            let d = self.projectSnap as DataSnapshot
            var projStr: String = ""
            if key! != "", let i = d.value as? [String:Any]{
                let p = i[key!] as? [String:Any]
                projStr = p!["name"] as! String
            }
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
            proj.setTitle("\(projStr)" , for: .normal)
            return cell
        }
    }
}
extension TimerViewController: UITableViewDataSource{
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
    
}
