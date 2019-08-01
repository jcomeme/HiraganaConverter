//
//  ViewController.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/01.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HiraganaConverterDelegate{
    
    @IBOutlet var inputField:UITextField!
    @IBOutlet var waitingScreenView:UIView!
    @IBOutlet var indicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func convert(){
        if let str = inputField.text{
            let converter = HiraganaConverter(delegate: self)
            converter.beginConversion(sentence: str)
            self.showWaitingScreen()
        }
    }
    
    func showWaitingScreen(){
        self.indicator.startAnimating()
        UIView.animate(withDuration: 3, animations: {
            self.waitingScreenView.isHidden = false
        })
    }
    
    func hideWaitingScreen(){
        self.indicator.stopAnimating()
        UIView.animate(withDuration: 3, animations: {
            self.waitingScreenView.isHidden = true
        })
    }

    func didTranslate(_ string: String) {
        print(string)
        self.hideWaitingScreen()
    }
    
    func errorOccured(_ string: String) {
        self.hideWaitingScreen()
        print(string)
        let controller = UIAlertController.init(title: "エラー", message: string, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }

    

}

