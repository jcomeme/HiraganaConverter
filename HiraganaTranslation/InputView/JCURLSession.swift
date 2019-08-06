//
//  JCURLSession.swift
//
//  Created by JCOmeme on 2017/03/09.
//  Copyright © 2017 JCOmeme. All rights reserved.
//

import Foundation



protocol JCURLSessionDelegate{
    func didReceiveError(_ error:String)
    func didReceiveData(_ data:Data)
}



//Just wrapper of URLSession.
class JCURLSession: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate{
    
    
    var delegate:JCURLSessionDelegate?
    var strData:Data?
    var task:URLSessionDataTask?
    
    
    required init(delegate dlg:JCURLSessionDelegate){
        super.init()
        self.delegate = dlg
    }

    func httpRequest(url:String, method:String?, payload:String?){
        strData = nil
        strData = Data()
        
        let config = URLSessionConfiguration.background(withIdentifier: "bgreq")
        config.timeoutIntervalForRequest = TimeInterval(10)
        config.timeoutIntervalForResource = TimeInterval(60 * 60 * 24)
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        if let uri = URL(string: url), let met = method, let pl = payload{
            //リクエスト生成
            var request: URLRequest = URLRequest(url: uri)
            request.httpMethod = met
            let myData: Data = pl.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            request.httpBody = myData as Data
            
            self.task = session.dataTask(with: request)
            task?.resume()
        }else{
            self.delegate?.didReceiveError("URLが有効ではないよ")
            session.invalidateAndCancel()
        }
    }
    
    
    func cancelTask(){
        task?.cancel()
    }

    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.strData?.append(data)
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let er = error{
            self.delegate?.didReceiveError(er.localizedDescription)
        }else{
            self.delegate?.didReceiveData(strData!)
        }
        session.invalidateAndCancel()
    }
    
}
