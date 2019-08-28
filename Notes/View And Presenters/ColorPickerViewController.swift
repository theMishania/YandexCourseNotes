//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Мишаня on 08/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var colorPickerView: ColorPickerView!
    var colorComletion: ((UIColor) ->())?
    public var color: UIColor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        self.navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
    }
    
    
    private func prepareUI(){
        colorPickerView.buttonTappedCompletion = { [unowned self] color in
            self.colorComletion?(color)
            self.navigationController?.popViewController(animated: true)
        }
        colorPickerView.colorPalatteView.isCircle = true
        colorPickerView.colorPalatteView.isPalatte = true
        if let color = self.color{
            colorPickerView.setColor(color)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
