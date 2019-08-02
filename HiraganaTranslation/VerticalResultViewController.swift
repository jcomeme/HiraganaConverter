//
//  VerticalResultViewController.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/02.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit

class VerticalResultViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let tm = TextModel()
    var bgColor:UIColor = #colorLiteral(red: 0.9935216294, green: 1, blue: 0.9316253562, alpha: 1)
    var pvc = UIPageViewController.init()
    var currentPage = 0
    var delegate:ViewController?
    var originalSentence:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let sz = UIScreen.main.bounds.size
        let rect = CGRect.init(x: ((1 / 30) * sz.width), y: ((7 / 112) * sz.height), width: ((14 / 15) * sz.width), height: (0.9 * sz.height))
        
        self.view.backgroundColor = bgColor
        tm.setContent(content: originalSentence ?? "", rect: rect)
        // Do any additional setup after loading the view.
        tm.fontSize = 20
        tm.fontName = "HiraMinProN-W3"
        tm.createPage()

        pvc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pvc.dataSource = self
        pvc.delegate = self
        
        
        self.addChild(pvc)

        pvc.setViewControllers([self.makePage(currentPage)], direction: .forward , animated: false, completion: nil)
        self.view.addSubview(pvc.view)
        pvc.view.frame = CGRect.init(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 100)
        
        let closeButton = UIButton.init(type: .system)
        closeButton.addTarget(self, action: #selector(backToInput), for: .touchUpInside)
        closeButton.setTitle("戻る", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true

    }
    
    @objc func backToInput(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func makePage(_ page:Int) -> EachPageViewController{
        let tt = TTView.init(frame: self.tm.rect)
        tt.backgroundColor = self.bgColor
        tt.content = self.tm.content.attributedSubstring(from: NSRange.init(location: tm.pageRangeArray[page].location, length: tm.pageRangeArray[page].length) )
        
        let ev = EachPageViewController()
        ev.ttt = tt
        ev._page = page
        return ev
    }


    
    func sliderMoved(_ page:Int){
        print(page)
        pvc.setViewControllers([self.makePage(page)], direction: .forward , animated: false, completion: nil)
        self.currentPage = page
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if 0 <= (self.currentPage - 1) {
            return makePage(self.currentPage - 1)
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.tm.pageRangeArray.count > (self.currentPage + 1) {
            return makePage(self.currentPage + 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let pc = pageViewController.viewControllers![0] as! EachPageViewController
            self.currentPage = pc._page
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
