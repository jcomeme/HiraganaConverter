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

enum XMLReadingMode:String{
    case none = "none"
    case surface = "surface"
    case furigana = "furigana"
}


//Convert sentence to hiragana.
class HiraganaConverter: NSObject, JCURLSessionDelegate, XMLParserDelegate {
    
    
    let appID = "dj00aiZpPUVSWFN2cWozMkl4ViZzPWNvbnN1bWVyc2VjcmV0Jng9ODY-"
    var delegate:HiraganaConverterDelegate?
    var mode:XMLReadingMode = .none
    var tempStringDict = [["surface":"", "furigana":""]]
    var resultString = ""
    
    
    required init(delegate dlg:HiraganaConverterDelegate){
        super.init()
        self.delegate = dlg
    }
    
    
    func beginConversion(sentence:String){
        let str:String = "appid=" + self.appID + "&sentence=" + sentence + "&grade=1"
        let session = JCURLSession(delegate: self)
        session.httpRequest(url: "https://jlp.yahooapis.jp/FuriganaService/V1/furigana",
                            method: "POST",
                            payload: str)
    }
    
    
    //JCURLSessionDelegate method
    func didReceiveData(_ data: Data) {
        //print(String(data:data, encoding: String.Encoding.utf8))
        let parser = XMLParser.init(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    //JCURLSessionDelegate method
    func didReceiveError(_ error: String) {
        self.delegate?.errorOccured(error)
    }
    
    
    //XMLParserDelegate method
    func parserDidStartDocument(_ parser: XMLParser) {
        self.resultString = ""
    }
    
    //XMLParserDelegate method
    func parserDidEndDocument(_ parser: XMLParser) {
        self.delegate?.didConvert(resultString)
    }

    //XMLParserDelegate method
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        writeToTemp(string)
    }
    
    //XMLParserDelegate method
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Surface"{
            self.mode = .surface
        }else if elementName == "Furigana"{
            self.mode = .furigana
        }else if elementName == "SubWordList"{
            self.tempStringDict = [["surface":"", "furigana":""]]
        }
    }
    
    //XMLParserDelegate method
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.mode = .none
        if elementName == "Word"{
            for item in self.tempStringDict{
                if item["furigana"]!.count > 0, item["surface"]!.isHiragana == false{
                    let str = "|" + item["surface"]! + "《" + item["furigana"]! + "》"
                    resultString += str
                }else if item["surface"]!.count > 0{
                    resultString += item["surface"]!
                }
            }
            self.tempStringDict = [["surface":"", "furigana":""]]
        }else if elementName == "SubWord"{
            self.tempStringDict.append(["surface":"", "furigana":""])
        }
    }

    //XMLParserDelegate method
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.delegate?.errorOccured(parseError.localizedDescription)
        parser.abortParsing()
    }
    
    
    func writeToTemp(_ str:String){
        if self.mode != .none{
            tempStringDict[tempStringDict.endIndex - 1][self.mode.rawValue] = str
        }
    }
    
    
}
