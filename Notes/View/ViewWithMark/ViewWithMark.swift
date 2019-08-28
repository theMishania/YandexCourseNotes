//
//  ViewWithMark.swift
//  TableViewStaticCells
//
//  Created by Мишаня on 04/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

@IBDesignable
class ViewWithMark: UIView {
    
    @IBOutlet weak var mark: MarkView!
    @IBOutlet weak var background: ColorPalatteView!
    @IBInspectable var color: UIColor = .white{
        didSet{
            background.isCircle = false
            background.isPalatte = false
            background.backgroundColor = color
        }
    }
    @IBInspectable public var chosen: Bool = true{
        didSet{
            mark.isHidden = !chosen
        }
    }
    
    var closureOnChosen: (() -> ())?
    
    public var comletionOnLongPress: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        addLongPressGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
        addLongPressGesture()
    }
    
//    override var intrinsicContentSize: CGSize{
//        return UIView().intrinsicContentSize
//    }
    
    private func loadFromXIB() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ViewWithMark", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setUpViews(){
        let xibView = loadFromXIB()
        xibView.frame = self.bounds
        self.addSubview(xibView)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        
         addTapGetsture()
    }

    private func addTapGetsture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(togleMark))
        self.addGestureRecognizer(tap)
    }
    
    @objc func togleMark(){
        guard !background.isPalatte else {return}
        closureOnChosen?()
        self.chosen.toggle()
    }
    
    private func addLongPressGesture(){
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        self.addGestureRecognizer(longTap)
    }
    
    @objc private func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .ended{
            comletionOnLongPress?()
        }
    }
}
