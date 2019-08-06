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
    var tempStringDictArray = [["surface":"", "furigana":""]]
    var resultString = ""
    var myParser:XMLParser?
    var mySession:JCURLSession?
    
    //If user add own ruby, the word skip to add ruby.
    var userRuby = false
    
    
    required init(delegate dlg:HiraganaConverterDelegate){
        super.init()
        self.delegate = dlg
    }
    
    func beginConversion(sentence:String){
        let str:String = "appid=" + self.appID + "&sentence=" + sentence + "&grade=1"
        mySession = JCURLSession(delegate: self)
        mySession?.httpRequest(url: "https://jlp.yahooapis.jp/FuriganaService/V1/furigana",
                            method: "POST",
                            payload: str)
    }
    
    func cancelTask(){
        self.mySession?.cancelTask()
        self.myParser?.abortParsing()
    }
    
    //JCURLSessionDelegate method
    func didReceiveData(_ data: Data) {
        //print(String(data:data, encoding: String.Encoding.utf8))
        myParser = XMLParser.init(data: data)
        myParser?.delegate = self
        myParser?.parse()
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
        if string == "|" || string == "｜"{
            userRuby = true
        }
        if string == "》"{
            userRuby = false
        }
        writeToTemp(string)
        print(string)
    }
    
    //XMLParserDelegate method
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        /*
         Change the "Mode" along by element name.
         If the word has subwords,
         clear temporary dictionary array
         to add just only subword to temporary dictionary.
         */
        if elementName == "Surface"{
            self.mode = .surface
        }else if elementName == "Furigana"{
            self.mode = .furigana
        }else if elementName == "SubWordList"{
            self.tempStringDictArray = [["surface":"", "furigana":""]]
        }
    }
    
    //XMLParserDelegate method
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        self.mode = .none
        
        if elementName == "Word"{
            /*
             As the word element is closed,
             stringify temporary dictionary array
             using "Narou ruby style".
             */
            for item in self.tempStringDictArray{
                if item["furigana"]!.count > 0, item["surface"]!.isHiragana == false{
                    let str = "|" + item["surface"]! + "《" + item["furigana"]! + "》"
                    resultString += str
                }else if item["surface"]!.count > 0{
                    resultString += item["surface"]!
                }
            }
            self.tempStringDictArray = [["surface":"", "furigana":""]]
        }else if elementName == "SubWord"{
            self.tempStringDictArray.append(["surface":"", "furigana":""])
        }
    }

    //XMLParserDelegate method
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.delegate?.errorOccured(parseError.localizedDescription)
        parser.abortParsing()
    }
    
    
    func writeToTemp(_ str:String){
        //Write string to temporary dictionary along by mode state.
        if self.mode != .none{
            if !(self.mode == .furigana && userRuby == true){
                tempStringDictArray[tempStringDictArray.endIndex - 1][self.mode.rawValue] = str
            }
        }
    }
    
    
}
