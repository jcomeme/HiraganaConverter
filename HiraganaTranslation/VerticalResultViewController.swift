//
//  VerticalResultViewController.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/02.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit

class VerticalResultViewController: UIViewController {

    var tm:TextModel?
    let tt:TTView = TTView()
    var bgColor:UIColor = #colorLiteral(red: 0.9935216294, green: 1, blue: 0.9316253562, alpha: 1)
    var delegate:ViewController?
    var originalSentence:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        
        
        tm = TextModel.init(content: originalSentence ?? "")
        tm?.fontSize = 20
        tm?.fontName = "HiraMinProN-W3"
        let cont = tm?.createAttributedString()
        tt.content = cont ?? NSAttributedString()
        
        tt.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = bgColor
        self.view.addSubview(tt)
        tt.backgroundColor = bgColor
        tt.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:60).isActive = true
        tt.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:-60).isActive = true
        tt.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:40).isActive = true
        tt.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-40).isActive = true

        let closeButton = UIButton.init(type: .system)
        closeButton.addTarget(self, action: #selector(backToInput), for: .touchUpInside)
        closeButton.setTitle("戻る", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true

    }
    
    @objc func backToInput(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func onOrientationDidChange(){
        tt.setNeedsDisplay()
    }


}
