//
//  NotesPresenter.swift
//  Notes
//
//  Created by Мишаня on 26/08/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

@objc
protocol NotesPresenterProtocol: class {
    var notesCount: Int { get }
    @objc
    func addNoteDidTapped()
    func didSelectRow(atIndexPath indexPath: IndexPath)
    
    func getTitleForNote(at indexPath: IndexPath) -> String
    func getContentForNote(at indexPath: IndexPath) -> String
    func getColorForNote(at indexPath: IndexPath) -> UIColor
    
    func removeNote(at indexPath: IndexPath)
    func requestTokenIfNeeded()
}

class NotesPresenter {
    unowned var view: NotesViewProtocol
    private var notebook: FileNotebook = FileNotebook()
    
    init(view: NotesViewProtocol) {
        self.view = view
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            notebook.backgroundContex = appDelegate.container.newBackgroundContext()
        }
        loadNotes()
    }
    
    private func pushDetailViewController(note: Note?, comletion: @escaping (Note) -> ()){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! TableViewController
        let detailPresenter = DetailPresenter(view: detailVC)
        detailVC.presenter = detailPresenter
        detailPresenter.note = note
        detailPresenter.saveCompletion = comletion
        view.pushViewController(detailVC)
    }
    
    private func loadNotes(){
        let loadOperation = LoadNotesOperation(notebook: notebook)
        loadOperation.uiComletion = {
            self.view.updateTableView()
        }
        
        OperationQueue.main.addOperation(loadOperation)
    }
}

extension NotesPresenter: NotesPresenterProtocol {
    var notesCount: Int {
        return notebook.notes.count
    }
    
    @objc
    func addNoteDidTapped() {
        pushDetailViewController(note: nil) { (note) in
            self.notebook.add(note)
            self.view.tableViewInsertRow(at: IndexPath(row: self.notebook.notes.count - 1, section: 0))
            let saveOperation = SaveNoteOperation(notebook: self.notebook)
            OperationQueue.main.addOperation(saveOperation)
        }
        view.tableViewEndEditing()
    }
    
    func didSelectRow(atIndexPath indexPath: IndexPath) {
        pushDetailViewController(note: notebook.notes[indexPath.row]) { (note) in
            self.notebook.replaceNote(atIndex: indexPath.row, with: note)
            self.view.tableViewUpdateRow(at: indexPath)
            let saveOperation = SaveNoteOperation(notebook: self.notebook)
            OperationQueue().addOperation(saveOperation)
        }
    }
    
    func getTitleForNote(at indexPath: IndexPath) -> String {
        return notebook.notes[indexPath.row].title
    }
    
    func getContentForNote(at indexPath: IndexPath) -> String {
        return notebook.notes[indexPath.row].content
    }
    
    func getColorForNote(at indexPath: IndexPath) -> UIColor {
        return notebook.notes[indexPath.row].color
    }
    
    func removeNote(at indexPath: IndexPath) {
        let removeOperation = RemoveNoteOperation(uid: notebook.notes[indexPath.row].uid, notebook: notebook)
        removeOperation.uiComletion = {
            self.view.tableViewDeleteRow(at: indexPath)
        }
        removeOperation.start()
    }
    
    func requestTokenIfNeeded() {
        let token = UserDefaults.standard.object(forKey: "accessToken") as? String
        if token == nil{
            let navController = UINavigationController(rootViewController: AuthViewController())
            view.presentViewController(navController)
        }
    }
    
}
