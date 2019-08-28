//
//  MarkView.swift
//  TableViewStaticCells
//
//  Created by Мишаня on 04/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

@IBDesignable
class MarkView: UIView {

    public var strokeColor = UIColor.black
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 2, dy: 2))
        circlePath.lineWidth = 1
        circlePath.stroke()
        
        let nikePath = UIBezierPath()
        
        nikePath.move(to: CGPoint(x: rect.midX, y: rect.maxY - 2))
        nikePath.addLine(to: CGPoint(x: rect.midX / 3, y: rect.midY))
        nikePath.move(to: CGPoint(x: rect.midX, y: rect.maxY - 2))
        nikePath.addLine(to: CGPoint(x: 0.85 * rect.maxX, y: rect.minY))
        
        nikePath.lineWidth = 1
        nikePath.stroke()
    }
 

}
