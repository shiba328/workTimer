//
//  overlay.swift
//  workTimer
//
//  Created by shiba on 2018/09/16.
//  Copyright © 2018年 shiba. All rights reserved.
//

import UIKit
import SpringIndicator

class DeviceConst {
    var overlay: UIView!
    func overlay(view: UIView) {
        overlay = UIView()
        let indicator = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        indicator.lineColors = [.cyan, .gray, .magenta, .yellow]
        indicator.lineWidth = 8
        indicator.center = view.center
        overlay.addSubview(indicator)
        indicator.start()
        
        overlay.frame = CGRect(x:0, y:0, width:view.bounds.width, height:view.bounds.height)
        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.addSubview(overlay)
    }
}
