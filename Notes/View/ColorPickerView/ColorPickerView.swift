//
//  ColorPickerView.swift
//  Notes
//
//  Created by Мишаня on 05/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerView: UIView {
    
    @IBOutlet weak var colorPalatteView: ColorPalatteView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var chooseButton: UIButton!
    public var buttonTappedCompletion: ((UIColor) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init called")
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    
    private func loadFromXib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPickerView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setUpViews(){
        let xibView = loadFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
        colorPalatteView.comletion = {[unowned self] color in
            self.setColor(color)
        }
    }
    
    public func setColor(_ color: UIColor){
        self.colorView.backgroundColor = color
        let buttonText = "Choose #" + String(format: "%06X", color.rgb >> 8)
        self.chooseButton.setTitle(buttonText, for: .normal)
    }
    
    @IBAction func chooseButtomTapped(_ sender: UIButton){
        buttonTappedCompletion?(self.colorView.backgroundColor ?? .white)
    }
    

}
