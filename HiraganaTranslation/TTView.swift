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

    
    var content:NSAttributedString = NSAttributedString()
    var range:CFRange = CFRangeMake(0, 0)

    
    
    override func draw(_ rect: CGRect) {
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
