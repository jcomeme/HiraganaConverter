//
//  TextModel.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/02.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit
import CoreText

class TextModel: NSObject{

    
    var originalText = ""
    var fontSize: CGFloat = 20
    var fontName = "HiraMinProN-W3"

    
    
    
    required init(content:String) {
        self.originalText = content
    }

    
    func sizeOfView(size:CGSize, attrStr:NSAttributedString) -> CGSize{
        var pageArray = [CFRange]()
        let path:CGMutablePath = CGMutablePath();
        let bounds:CGRect = CGRect(x: 0, y: 0 , width:size.height , height:(size.width / 4))//幅と高さを
        path.addRect(bounds)
        let framesetter :CTFramesetter = CTFramesetterCreateWithAttributedString(attrStr);
        var range = CFRangeMake(0, 0)
        var indexCounter = 0
        var counter = 0
        
        var lastRange = CFRangeMake(0, 0)
        
        while(true){
            print(counter)
            counter += 1
            print(indexCounter)
            
            //let csize:CGSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, size, nil)
            
            let frame:CTFrame = CTFramesetterCreateFrame(framesetter, range, path, nil);
            let tempRange = CTFrameGetVisibleStringRange(frame)
            if tempRange.length == 0{
                break
            }
            lastRange = tempRange
            pageArray.append(tempRange)
            indexCounter += tempRange.length
            range = CFRangeMake(indexCounter, 0)
        }
        return CGSize(width: Int(CGFloat(pageArray.count) * (size.width) / 4), height: Int(size.height))
    }
    
    
    
    func createAttributedString() -> NSAttributedString{
        
        let font = UIFont.init(name: fontName, size: fontSize)
        let leading = (font?.lineHeight)! - (font?.ascender)! + (font?.descender)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = leading
        
        
        var starr = [String]()
        let _ = originalText
            .replace(pattern: ",", template: "@c.oinu.csepa@")
            .replace(pattern: "([\\|｜].+?《.+?》)", template: ",$1,")
            .replace(pattern: "(\n|\r|\r\n)", template: ",\n,")
            .components(separatedBy: ",").map{
                $0.replace(pattern:"([\\|｜])", template:("@oinubar@"))
            }.map{
                if $0.substring(0 ..< 9) != "@oinubar@"{
                    let temp = $0.replace(pattern: "(\\p{Han}+?《.+?》)", template: ",@oinubar@$1,").components(separatedBy: ",")
                    for item in temp{
                        starr.append(item)
                    }
                }else{
                    starr.append($0)
                }
        }
        
        let attrstring = starr
            .map{
                $0.replace(pattern: "(@c.oinu.csepa@)", template: ",")
            }
            .map{ x -> NSAttributedString in
                if let pair = x.find(pattern: "@oinubar@(.+?)《(.+?)》") {
                    let string = (x as NSString).substring(with: pair.range(at: 1))
                    let ruby = (x as NSString).substring(with: pair.range(at: 2))
                    
                    
                    var text: [Unmanaged<CFString>?] = [Unmanaged<CFString>.passRetained(ruby as CFString) as Unmanaged<CFString>, .none, .none, .none]
                    let annotation = CTRubyAnnotationCreate(.auto, .auto, 0.5, &text[0])
                    return NSAttributedString(
                        string: string,
                        attributes:  [kCTRubyAnnotationAttributeName as NSAttributedString.Key: annotation,
                                      kCTVerticalFormsAttributeName as NSAttributedString.Key: true,
                                      kCTFontAttributeName as NSAttributedString.Key: font!,
                                      NSAttributedString.Key.paragraphStyle: paragraphStyle]
                    )
                } else {
                    return NSAttributedString(
                        string: x,
                        attributes:  [kCTVerticalFormsAttributeName as NSAttributedString.Key: true,
                                      kCTFontAttributeName as NSAttributedString.Key: font!,
                                      NSAttributedString.Key.paragraphStyle: paragraphStyle]
                    )
                }
                
            }.reduce(NSMutableAttributedString()) {
                $0.append($1);
                return $0
        }
        
        return attrstring
    }
    
    
    
    
    
}




extension String {
    var isHiragana: Bool {
        let range = "^[、-ゞ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    func substring(_ r: CountableRange<Int>) -> String {
        
        let length = self.count
        let fromIndex = (r.startIndex > 0) ? self.index(self.startIndex, offsetBy: r.startIndex) : self.startIndex
        let toIndex = (length > r.endIndex) ? self.index(self.startIndex, offsetBy: r.endIndex) : self.endIndex
        
        if fromIndex >= self.startIndex && toIndex <= self.endIndex {
            return String(self[fromIndex..<toIndex])
        }
        
        return String(self)
    }
    
    func substring(_ r: CountableClosedRange<Int>) -> String {
        
        let from = r.lowerBound
        let to = r.upperBound
        
        return self.substring(from..<(to+1))
    }
    
    func substring(_ r: CountablePartialRangeFrom<Int>) -> String {
        
        let from = r.lowerBound
        let to = self.count
        
        return self.substring(from..<to)
    }
    
    func substring(_ r: PartialRangeThrough<Int>) -> String {
        
        let from = 0
        let to = r.upperBound
        
        return self.substring(from..<to)
    }
    func find(pattern: String) -> NSTextCheckingResult? {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.firstMatch(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count))
        } catch {
            return nil
        }
    }
    
    func replace(pattern: String, template: String) -> String {
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            return re.stringByReplacingMatches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.utf16.count),
                withTemplate: template)
        } catch {
            print("err")
            return self
        }
    }
}
