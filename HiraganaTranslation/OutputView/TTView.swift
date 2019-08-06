//
//  TTView.swift
//  HiraganaTranslation
//
//  Created by YoshinobuHARA on 2019/08/02.
//  Copyright © 2019 OmemeAnkohji. All rights reserved.
//

import UIKit


//View for vertical writing.
class TTView: UIView {
    
    /* References:
     https://debuyan.wordpress.com/2017/05/15/swift3%E3%81%A7coretext%E3%81%A7%E3%81%AE%E7%B8%A6%E6%9B%B8%E3%81%8D/
     */

    
    var content:NSAttributedString = NSAttributedString()
    
    override func draw(_ rect: CGRect) {
        
        let range = CFRangeMake(0, content.length)
        
        let context:CGContext = UIGraphicsGetCurrentContext()! //初期化
        context.translateBy(x: 0, y: 0) //座標中心を左下に持ってくる。
        context.scaleBy(x: 1.0, y: -1.0) // 反転させる。（これをしないと文字が逆になる）
        context.textMatrix = CGAffineTransform.identity //それまでの修飾をクリア？
        context.rotate(by: -CGFloat(Double.pi/2)) //文字だけで無く文章が縦になるように、領域を90度回転する。
        
        let path:CGMutablePath = CGMutablePath();
        
        let bounds:CGRect = CGRect(x: 0, y:0 , width:self.bounds.size.height, height:self.bounds.size.width)//幅と高さを
        path.addRect(bounds)
        
        let framesetter :CTFramesetter = CTFramesetterCreateWithAttributedString(content);
        let frame:CTFrame = CTFramesetterCreateFrame(framesetter,range, path, nil);
        
        CTFrameDraw(frame, context);
    }


}
