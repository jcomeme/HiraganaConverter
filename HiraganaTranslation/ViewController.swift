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
    @IBOutlet var inputViewSet:UIView!
    @IBOutlet var yConstraint:NSLayoutConstraint!
    
    var originalSentence:String?
    var hiraganaResult:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To move inputViewSet when software keyboard will be shown or hidden.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    
    @IBAction func convert(){
        if let str = inputField.text, str.count > 0{
            self.originalSentence = str
            let converter = HiraganaConverter(delegate: self)
            converter.beginConversion(sentence: str)
            self.showWaitingScreen()
        }
    }
    
    @IBAction func viewWasTaped(){
        self.inputField.resignFirstResponder()
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

    
    //HiraganaConverterDelegate method
    func didConvert(_ string: String) {

        self.hiraganaResult = string
        self.hideWaitingScreen()
        //self.performSegue(withIdentifier: "showResultSegue", sender: self)
        let vert = VerticalResultViewController()
        vert.delegate = self
        vert.originalSentence = self.hiraganaResult
        self.present(vert, animated: true, completion: nil)
    }
    
    
    //HiraganaConverterDelegate method
    func errorOccured(_ string: String) {
        self.hideWaitingScreen()
        let controller = UIAlertController.init(title: "エラー", message: string, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    

    

    // Move inputViewSet when keyboard will be shown.
    @objc func keyboardWillShow(_ notification:Notification){
        self.view.layoutIfNeeded()
        
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let keyboardOrigin = keyboardInfo.cgRectValue.origin
        
        if (inputViewSet.frame.origin.y + inputViewSet.frame.size.height) > keyboardOrigin.y {
            UIView.animate(withDuration: duration, animations: {
                self.yConstraint.isActive = false
                self.yConstraint = self.inputViewSet.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:(-keyboardSize.height))
                self.yConstraint.isActive = true
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // Move inputViewSet to self.view.centerY when keyboard will be hidden.
    @objc func keyboardWillHide(_ notification:Notification){
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: duration, animations: {
            self.yConstraint.isActive = false
            self.yConstraint = self.inputViewSet.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.yConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }
}

