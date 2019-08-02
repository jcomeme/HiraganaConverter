//
//  EachPageViewController.swift
//  Reader2
//
//  Created by YoshinobuHARA on 2018/02/01.
//  Copyright © 2018年 JCOmeme. All rights reserved.
//

import UIKit

class EachPageViewController: UIViewController {
    
    var ttt:TTView? = nil
    var _page:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.ttt!)

    }
    


    
}

