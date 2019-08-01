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
    
    var originalSentence:String?
    var hiraganaResult:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func convert(){
        if let str = inputField.text, str.count > 0{
            self.originalSentence = str
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
        self.hiraganaResult = string
        self.hideWaitingScreen()
        self.performSegue(withIdentifier: "showResultSegue", sender: self)
    }
    
    func errorOccured(_ string: String) {
        self.hideWaitingScreen()
        print(string)
        let controller = UIAlertController.init(title: "エラー", message: string, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultSegue" {
            let vc = segue.destination as! ResultViewController
            vc.delegate = self
            vc.originalSentence = self.originalSentence
            vc.hiraganaResult = self.hiraganaResult
        }
    }

    

}

