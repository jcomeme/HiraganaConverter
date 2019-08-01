//
//  ResultViewController.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/01.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet var originalSentenceLabel:UILabel!
    @IBOutlet var hiraganaResultLabel:UILabel!
    
    var delegate:ViewController?
    var originalSentence:String?
    var hiraganaResult:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.originalSentenceLabel.text = self.originalSentence ?? ""
        self.hiraganaResultLabel.text = self.hiraganaResult ?? ""
        
    }
    

    @IBAction func backToInput(){
        self.delegate?.inputField.text = ""
        self.dismiss(animated: true, completion: nil)
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
