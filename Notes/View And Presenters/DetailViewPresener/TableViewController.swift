//
//  TableViewController.swift
//  TableViewStaticCells
//
//  Created by Мишаня on 04/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

protocol DetailViewProtocol: class {
    func reloadTableViewSection(at index: Int)
    func setDateTextFieldActive()
    func toggleDestroyDate()
    func popFromNavController()
    func setDatePickerText(_ text: String)
    func fillViewWithData(title: String, content: String, date: String?, color: UIColor)
}

class TableViewController: UITableViewController, UITextViewDelegate {
    
    private var height: CGFloat = 0
    private var destroyDateIsActive = false
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak  var colorPalatteView: ColorPalatteView!
    @IBOutlet var colorViews: [ViewWithMark]!
    @IBOutlet weak  var dateSwitch: UISwitch!
    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        prepareUI()
        presenter.didReceiceNote()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2 && destroyDateIsActive{
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            if height == 0 {
                return textView.textInputView.frame.height
            }
            return height < 44 ? 44 : height
        }
        else if indexPath.section == 3{
            return 90
        }
        return 44
    }
    
    
    @IBAction func dateSwitchChanged(_ sender: UISwitch) {
        presenter.dateSwitched()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        guard height != textView.textInputView.frame.height else {return}
        height = textView.textInputView.frame.height
        tableView.reloadSections([1], with: .none)
        textView.becomeFirstResponder()
    }
    
    @IBAction func tap(_ sender: UIGestureRecognizer){
        tableView.endEditing(true)
    }
    
    private func prepareUI(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormatter.string(from: Date())
        dateTextField.tintColor = .white
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        setUpChosenViews()
        setUpPalatteView()
        addNavButtons()
        
    }
    
    private func addNavButtons(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAndDismiss))
    }
    
    @objc private func saveAndDismiss(){
        presenter.createNoteFromFields(title: titleTextField.text!, content: textView.text, dateString: dateTextField.text, colorViews: colorViews)
    }
    
    private func setUpChosenViews(){
        for view in colorViews{
            view.closureOnChosen = {[unowned self] in
                self.clearAllMarks()
            }
        }
    }
    
    private func clearAllMarks(){
        for colorView in self.colorViews{
            colorView.chosen = false
        }
    }
    
    private func setUpPalatteView(){
        colorViews[3].background.isPalatte = true
        colorViews[3].comletionOnLongPress = {[unowned self] in
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let colorPickerVC = storyboard.instantiateViewController(withIdentifier: "colorPicker") as! ColorPickerViewController
            if !self.colorViews[3].background.isPalatte{
                colorPickerVC.color = self.colorViews[3].color
            }
            colorPickerVC.colorComletion = {[unowned self] color in
                self.appendColor(color)
            }
            self.navigationController?.pushViewController(colorPickerVC, animated: true)
        }
    }
    
    @objc private func datePickerChanged(datePicker: UIDatePicker){
        presenter.datePickerTextChanged(date: datePicker.date)
    }
    
    private func appendColor(_ color: UIColor){
        colorViews[3].color = color
        colorViews[3].backgroundColor = color
        clearAllMarks()
        colorViews[3].chosen = true
    }

}


/*
 Detail View Protocol Extension
 */
extension TableViewController: DetailViewProtocol {
    

    func reloadTableViewSection(at index: Int) {
        tableView.reloadSections([index], with: .none)
    }
    
    func setDateTextFieldActive() {
        tap(UIGestureRecognizer(target: nil, action: nil))
        if destroyDateIsActive{
            dateTextField.becomeFirstResponder()
        }
    }
    
    func popFromNavController() {
        navigationController?.popViewController(animated: true)
    }
    
    func setDatePickerText(_ text: String) {
        dateTextField.text = text
    }
    
    func fillViewWithData(title: String, content: String, date: String?, color: UIColor) {
        titleTextField.text = title
        textView.text = content
        if let date = date{
            destroyDateIsActive = true
            dateTextField.text = date
            dateSwitch.isOn = true
        }
        appendColor(color)
    }
    
    func toggleDestroyDate() {
        destroyDateIsActive.toggle()
    }
    
}
