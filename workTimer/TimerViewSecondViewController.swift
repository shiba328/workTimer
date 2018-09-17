//
//  TimerViewSecondViewController.swift
//  workTimer
//
//  Created by shiba on 2018/09/17.
//  Copyright © 2018年 shiba. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ModalViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    var projectItems: [[String : Any]] = []
    var selectProject: [String:Any] = [:]
    
    // StoryboardとUIButtonをつなぎます
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let visualEffectView = UIVisualEffectView(frame: view.frame)
        visualEffectView.effect = UIBlurEffect(style: .regular)
        view.insertSubview(visualEffectView, at: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: false)
    }
}

extension ModalViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellをつくる
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        //中身ない場合は一旦データなしを追加
        let title = cell.viewWithTag(1) as! UILabel
        
        if self.projectItems.count == 0{
            title.text = "データなし"
            return cell
        }else{
            title.text = self.projectItems[indexPath.row]["name"] as? String
            return cell
        }
        
    }
    // Cell が選択された場合
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if let presenter = presentingViewController as? TimerViewController {
            presenter.choiceProjrct = self.projectItems[indexPath.row]
            presenter.choiceLabel = self.projectItems[indexPath.row]["name"] as! String
        }
        dismiss(animated: false)
    }
    
}
extension ModalViewController: UITableViewDataSource{
    //Table Viewのセルの数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.projectItems.count == 0{
            return 1
        }else{
            return self.projectItems.count
        }
    }
    
}
