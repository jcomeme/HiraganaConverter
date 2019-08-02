//
//  HiraganaConverter.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/01.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit


protocol HiraganaConverterDelegate{
    func didConvert(_ string:String)
    func errorOccured(_ string:String)
}


//Convert sentence to hiragana.
class HiraganaConverter: NSObject, JCURLSessionDelegate {
    
    
    let appID = "e5603cc32e0049e2551bd5f52f6657691b4feb05902166189fe76da204b2437e"
    var delegate:HiraganaConverterDelegate?
    
    
    required init(delegate dlg:HiraganaConverterDelegate){
        super.init()
        self.delegate = dlg
    }
    

    func beginConversion(sentence:String){
        let session = JCURLSession(delegate: self)
        struct RequestBody:Codable {
            let app_id:String
            let sentence:String
            let output_type:String
        }
        
        let requestBody = RequestBody.init(app_id: appID, sentence: sentence, output_type: "hiragana")
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(requestBody)
            let jsonstr:String = String(data: data, encoding: .utf8)!
            session.jSONHttpRequest(url: "https://labs.goo.ne.jp/api/hiragana",
                                    method: "POST",
                                    jSON: jsonstr)
        } catch {
            self.delegate?.errorOccured(error.localizedDescription)
        }
    }
    
    
    //JCURLSessionDelegate method
    func didReceiveData(_ data: Data) {
        do {
            let items = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
            
            if items.keys.contains("error"){
                let errDict = items["error"] as? Dictionary<String, Any> ?? Dictionary()
                if let msg = errDict["message"] as? String{
                    self.delegate?.errorOccured(msg)
                }else{
                    self.delegate?.errorOccured("不明なエラーです")
                }
            }else{
                if items.keys.contains("converted"), let converted = items["converted"] as? String{
                    self.delegate?.didConvert(converted)
                }else{
                    self.delegate?.errorOccured("不明なエラーです")
                }
            }
        } catch(let err) {
            self.delegate?.errorOccured(err.localizedDescription)
        }
    }
    
    
    //JCURLSessionDelegate method
    func didReceiveError(_ error: String) {
        self.delegate?.errorOccured(error)
    }
    

}
