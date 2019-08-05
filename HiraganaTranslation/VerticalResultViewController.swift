//
//  VerticalResultViewController.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/02.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit

class VerticalResultViewController: UIViewController {

    var textModel:TextModel?
    let scrollView = UIScrollView()
    let tt:TTView = TTView()
    var bgColor:UIColor = #colorLiteral(red: 0.9935216294, green: 1, blue: 0.9316253562, alpha: 1)
    var delegate:ViewController?
    var originalSentence:String?
    var attributedContent:NSAttributedString = NSAttributedString()
    var ttViewWidthConstraint:NSLayoutConstraint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:60).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:-10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-10).isActive = true
        
        
        self.textModel = TextModel.init(content: originalSentence ?? "")
        attributedContent = textModel?.createAttributedString() ?? NSAttributedString()
        
        tt.content = NSAttributedString()
        tt.backgroundColor = bgColor

        self.view.backgroundColor = bgColor
        scrollView.addSubview(tt)
        
        self.layoutPage()
        
        
        

        let closeButton = UIButton.init(type: .system)
        closeButton.addTarget(self, action: #selector(backToInput), for: .touchUpInside)
        closeButton.setTitle("戻る", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true

    }
    
    
    func layoutPage(){
        self.view.layoutIfNeeded()
        
        var size = textModel?.sizeOfView(size: CGSize(width: scrollView.frame.size.width, height:scrollView.frame.size.height - 20), attrStr: attributedContent)
        size!.width = max(scrollView.frame.size.width, (size!.width + 20))//To avoid cut off to be visible
        scrollView.contentSize = CGSize(width:size!.width, height:1)
        tt.frame = CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width:size!.width, height:scrollView.frame.size.height - 20))
        tt.content = attributedContent
        
        self.view.layoutIfNeeded()
    }
    
    
    
    @objc func backToInput(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func onOrientationDidChange(){
        self.layoutPage()
        tt.setNeedsDisplay()
    }


}


