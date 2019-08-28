//
//  DetailPresenter.swift
//  Notes
//
//  Created by Мишаня on 26/08/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

protocol DetailPresenterProtocol: class {
    func dateSwitched()
    func createNoteFromFields(title: String, content: String, dateString: String?, colorViews: [ViewWithMark])
    func datePickerTextChanged(date: Date)
    func didReceiceNote()
}

class DetailPresenter {
    unowned var view: DetailViewProtocol
    
    public var saveCompletion: ((Note) -> Void)?
    
    private var destroyDateIsActive = false
    public  var note: Note?
    
    init(view: DetailViewProtocol) {
        self.view = view
    }
    
}

extension DetailPresenter: DetailPresenterProtocol {
    func dateSwitched() {
        view.toggleDestroyDate()
        view.reloadTableViewSection(at: 2)
        view.setDateTextFieldActive()
    }
    
    func createNoteFromFields(title: String, content: String, dateString: String?, colorViews: [ViewWithMark]) {
        var color: UIColor = .white
        var date: Date? = nil
        let dateFormatter = DateFormatter()
        var resultNote: Note
        dateFormatter.dateFormat = "dd.MM.yyyy"
        for markView in colorViews{
            if markView.chosen{
                color = markView.background.backgroundColor!
            }
        }
        
        if destroyDateIsActive{
            date = dateFormatter.date(from: dateString!)
        }
        if self.note != nil{
            resultNote = Note(title: title, content: content, importance: .normal,
                              color: color, uid: note!.uid, date: date)
        }else{
            resultNote = Note(title: title, content: content, importance: .normal,
                              color: color, date: date)
        }
        saveCompletion?(resultNote)
        view.popFromNavController()
    }
    
    func datePickerTextChanged(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateText = dateFormatter.string(from: date)
        view.setDatePickerText(dateText)
    }
    
    func didReceiceNote() {
        guard let note = self.note else {return}
        var date: String? = nil
        if let dateTmp = note.selfDestructionDate{
            let dateFomatter = DateFormatter()
            dateFomatter.dateFormat = "dd.MM.yyyy"
            date = dateFomatter.string(from: dateTmp)
        }
        view.fillViewWithData(title: note.title, content: note.content, date: date, color: note.color)
    }
}
