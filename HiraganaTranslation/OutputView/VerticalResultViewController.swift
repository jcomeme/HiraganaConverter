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
    var delegate:InputViewController?
    var convertedSentence:String?
    var attributedContent:NSAttributedString = NSAttributedString()
    var ttViewWidthConstraint:NSLayoutConstraint?
    var isFiestTimeToDisplayContent = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.bgColor
        
        //Add back button to view.
        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(backToInput), for: .touchUpInside)
        closeButton.setTitle("戻る", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        //Add scrollview to view.
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:60).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:-10).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant:10).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:-10).isActive = true
        
        //Create attributedstring from rubiedtext.
        self.textModel = TextModel.init(content: self.convertedSentence ?? "")
        self.attributedContent = self.textModel?.createAttributedString() ?? NSAttributedString()
        
        //Add vertical text writing view to scrollview.
        self.tt.content = attributedContent
        self.tt.backgroundColor = self.bgColor
        self.scrollView.addSubview(self.tt)
        
        //Add orientation change notification.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onOrientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.layoutPage()
        self.scrollView.setContentOffset(CGPoint(x:scrollView.contentSize.width - scrollView.frame.width,
                                                 y:0),
                                         animated: false)
        self.view.layoutIfNeeded()
    }
    
    
    func layoutPage(){
        var size = textModel?.sizeOfView(size: CGSize(width: scrollView.frame.size.width,
                                                      height:scrollView.frame.size.height - 20),
                                         attrStr: attributedContent)
        
        //To avoid cut off to be visible
        size!.width = max(scrollView.frame.size.width, (size!.width + 20))
        
        
        /* Issue:
        Can not display text when ttview width is over about 8000px.
         */
        
        if size!.width > 8000{
            print("view size warning")
            let message = "すみません、ちょっとサイズが大きすぎて表示できませんでした。もう少し行数を減らしてください"
            let controller = UIAlertController.init(title: "エラー",
                                                    message: message,
                                                    preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default, handler: {(_) in
                self.dismiss(animated: true, completion:nil)
            })
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        }else{
            self.scrollView.contentSize = CGSize(width:size!.width, height:1)
            self.tt.frame = CGRect.init(origin: CGPoint(x: 0, y: 0),
                                        size: CGSize(width:size!.width,
                                                     height:scrollView.frame.size.height - 20))
        }
    }
    
    
    @objc func backToInput(){
        self.delegate?.inputTextView.text = ""
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc func onOrientationDidChange(){
        self.layoutPage()
        tt.setNeedsDisplay()
    }


}


