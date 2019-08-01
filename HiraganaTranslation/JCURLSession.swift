//
//  JCURLSession.swift
//
//  Created by JCOmeme on 2017/03/09.
//  Copyright © 2017 JCOmeme. All rights reserved.
//

import Foundation

protocol JCURLSessionDelegate{
    func didReceiveDataAsString(_ string:String)
    func didReceiveError(_ error:String)
    func didReceiveData(_ data:Data)
    func downloadProgress(_ progress:(Int64, Int64))
}



class JCURLSession: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate{
    
    var delegate:JCURLSessionDelegate?
    var strData:Data?
    
    
    
    required init(delegate dlg:JCURLSessionDelegate){
        super.init()
        delegate = dlg
    }
    
    
    func wget(_ iurl:String){
        strData = nil
        strData = Data()
        
        let config = URLSessionConfiguration.background(withIdentifier: "bgsess")
        config.timeoutIntervalForRequest = TimeInterval(5)
        config.timeoutIntervalForResource = TimeInterval(60 * 60 * 24)
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        if let url = URL(string: iurl){
            let task = session.downloadTask(with: url)
            task.resume()
        }else{
            delegate?.didReceiveError("URLが有効ではないよ")
            session.invalidateAndCancel()
        }
    }
    
    
    func cURL(_ iurl:String){
        strData = nil
        strData = Data()
        
        let config = URLSessionConfiguration.background(withIdentifier: "bgsess")
        config.timeoutIntervalForRequest = TimeInterval(10)
        config.timeoutIntervalForResource = TimeInterval(60 * 60 * 24)
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        if let url = URL(string: iurl){
            let task = session.dataTask(with: url)
            task.resume()
        }else{
            delegate?.didReceiveError("URLが有効ではないよ")
            session.invalidateAndCancel()
        }
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

            let task: URLSessionDataTask = session.dataTask(with: request)

            
            task.resume()
        }else{
            delegate?.didReceiveError("URLが有効ではないよ")
            session.invalidateAndCancel()
        }

    }
    
    func JSONHttpRequest(url:String, method:String?, JSON:String?){
        strData = nil
        strData = Data()
        
        let config = URLSessionConfiguration.background(withIdentifier: "bgreq")
        config.timeoutIntervalForRequest = TimeInterval(10)
        config.timeoutIntervalForResource = TimeInterval(60 * 60 * 24)
        
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        
        
        if let uri = URL(string: url), let met = method, let pl = JSON{
            
            //リクエスト生成
            var request: URLRequest = URLRequest(url: uri)
            request.httpMethod = met
            let myData: Data = pl.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            request.httpBody = myData as Data
            request.addValue("application/json; charaset=utf-8", forHTTPHeaderField: "Content-Type")
  
            
            let task: URLSessionDataTask = session.dataTask(with: request)
            
            
            task.resume()
        }else{
            delegate?.didReceiveError("URLが有効ではないよ")
            session.invalidateAndCancel()
        }
        
    }
    
    
    
    
    //delegate methods (data task)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        strData?.append(data)
    }
    
    
    
    //delegate method (session)
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let er = error{
            delegate?.didReceiveError(er.localizedDescription)
        }else{
            delegate?.didReceiveData(strData!)
            if let str = String(data: strData!, encoding: String.Encoding.utf8){
                delegate?.didReceiveDataAsString(str)
            }else{
                delegate?.didReceiveError("文字列にできない！？")
            }
        }
        session.invalidateAndCancel()
    }
    
    
    
    
    //delegate methods (download)


    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let dt:Data = try Data(contentsOf: location)
            delegate?.didReceiveData(dt)
        } catch  {
            delegate?.didReceiveError("ダウンロード失敗！")
        }
        session.invalidateAndCancel()
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        delegate?.downloadProgress( (totalBytesWritten, totalBytesExpectedToWrite) )
    }
    
}
