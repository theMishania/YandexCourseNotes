//
//  ColorPickerView.swift
//  ColorPickerViewTest
//
//  Created by Мишаня on 01/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

class ColorPalatteView: UIView{
    
    private var circleRadius: CGFloat!
    
    public var comletion: ((UIColor) -> ())?
    
    //public var comletionOnLongPress: (() -> ())?
    
    var isCircle: Bool = false{
        didSet{
            //setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var isPalatte: Bool = false{
        didSet{
            setNeedsDisplay()
            //setNeedsLayout()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addLongPressGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //addLongPressGesture()
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard isPalatte else {return}
        guard let context = UIGraphicsGetCurrentContext() else {return}
        circleRadius = (rect.maxY > rect.maxX) ? rect.maxX / 2 : rect.maxY / 2 //make circle radius equal to smallest edge
        for x in stride(from: rect.minX, to: rect.maxX, by: 0.7){
            for y in stride(from: rect.minY, to: rect.maxY, by: 0.7){
                let point = CGPoint(x: x, y: y)
                context.setFillColor(computeColor(of: point, in: rect))
                context.fill(CGRect(origin: point, size: CGSize(width: 1.4, height: 1.4)))
            }
        }
    }
    
    override func layoutSubviews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        if isCircle{
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
    }
    
//    private func addLongPressGesture(){
//        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
//        self.addGestureRecognizer(longTap)
//    }
    
    private func computeColor(of point: CGPoint, in rect: CGRect) -> CGColor{
        if isNotInCircle(point, in: rect){
            return UIColor.black.cgColor
        }
        if point == CGPoint(x: rect.midX, y: rect.midY){
            return UIColor.white.cgColor
        }
        let angle = computeAngle(to: point, in: rect)
        let color = colorOf(point, with: angle, in: rect)
        return color
    }
    
    private func isNotInCircle(_ point: CGPoint, in rect: CGRect) -> Bool{
        let vectorLength = lengthFromCircleOrigin(of: point, in: rect)
        if vectorLength > circleRadius{
            return true
        }
        return false
    }
    
    private func computeAngle(to point: CGPoint, in rect: CGRect) -> CGFloat{
        let deltaX = point.x - rect.midX
        let deltaY = point.y - rect.midY
        
        let angle = acos((-deltaY)/(sqrt(deltaX * deltaX + deltaY * deltaY)))
        return (point.x >= rect.midX) ? angle : (2 * CGFloat.pi - angle)
    }
    
    private func colorOf(_ point: CGPoint, with angle: CGFloat, in rect: CGRect) -> CGColor{
        let vectLength = lengthFromCircleOrigin(of: point, in: rect)
        let hue = angle / (2 * CGFloat.pi)
        let saturation = (vectLength < circleRadius / 2) ? vectLength / (circleRadius / 2) : 1
        let brightness = computeBrightness(with: vectLength)
        //print(hue, saturation, brightness)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1).cgColor
    }
    
    private func lengthFromCircleOrigin(of point: CGPoint, in rect: CGRect) -> CGFloat{
        let deltaX = point.x - rect.midX
        let deltaY = point.y - rect.midY
        let vectorLength = sqrt(deltaX * deltaX + deltaY * deltaY)
        return vectorLength
    }
    
    private func computeBrightness(with vectLength: CGFloat) -> CGFloat{
        let halfRadius = circleRadius / 2
        if (vectLength > halfRadius){
            return 1 - (vectLength - halfRadius) / halfRadius
        }
        return 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(_ touches: Set<UITouch>){
        guard isPalatte else {return}
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        if lengthFromCircleOrigin(of: location, in: self.bounds) >= circleRadius{
            return
        }
        let color = getPixelColor(atPosition: location)
        comletion?(color)
    }
    
    private func getPixelColor(atPosition:CGPoint) -> UIColor{
        
        var pixel:[CUnsignedChar] = [0, 0, 0, 0];
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let bitmapInfo = CGBitmapInfo(rawValue:    CGImageAlphaInfo.premultipliedLast.rawValue);
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue);
        
        context!.translateBy(x: -atPosition.x, y: -atPosition.y);
        layer.render(in: context!);
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0);
        
        return color;
        
    }
    
//    @objc private func longTap(_ sender: UIGestureRecognizer){
//        comletionOnLongPress?()
//    }

    
}
