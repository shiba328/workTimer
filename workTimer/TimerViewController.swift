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
import FirebaseDatabase
import FirebaseAuth

class TimerViewController: UIViewController{

    @IBOutlet weak var choiceBtn: UIButton!
    var ref: DatabaseReference!
    var projectSnap: DataSnapshot!
    var timerSnap: DataSnapshot!
    var timerItems: [[String : Any]] = []
    var projectItems: [[String : Any]] = []
    var choiceProjrct:[String : Any] = [:]
    var choiceLabel:String = "" {
        didSet{
            self.choiceBtn.setTitle(choiceLabel, for: .normal)
        }
    }
    var uid: String!
    var Timer = Foundation.Timer()
    var startTime: String!
    var count: Int = 0 {
        didSet{
            let hour = String(format: "%02i", count / 3600)
            let min = String(format: "%02i", count / 60 % 60)
            let sec = String(format: "%02i", count % 60)
            counterLabel.text = "\(hour):\(min):\(sec)"
        }
    }
    
    @IBOutlet weak var headInp: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var counterLabel: UILabel!

    @IBAction func choice(_ sender: Any) {

        let sb = UIStoryboard(name: "Modal", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ModalViewController
        // 背景が真っ黒にならなくなる
        vc.modalPresentationStyle = .overCurrentContext
        vc.projectItems = projectItems
        present(vc, animated: false)
    }

    override func viewDidLoad() {
        self.ref = Database.database().reference()
        let user = Auth.auth().currentUser
        self.uid = user?.uid
        getDatebase()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ユーザがキーボード以外の場所をタップすると、キーボードを閉じる
        self.view.endEditing(true)
    }
}
