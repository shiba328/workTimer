//
//  TimerViewController+UINavigationBar.swift
//  workTimer
//
//  Created by shiba on 2018/09/17.
//  Copyright © 2018年 shiba. All rights reserved.
//

import UIKit
import Firebase

extension TimerViewController{
    @IBAction func menu(_ sender: Any) {
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
}
