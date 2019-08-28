//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation{
    var notebook: FileNotebook
    
    var uiComletion: (() -> ())?
    
    var backendOperation: LoadNotesBackendOperation!
    var databaseOpearion: LoadNotesDBOperation!
    
    init(notebook: FileNotebook){
        self.notebook = notebook
        super.init()
        
        databaseOpearion = LoadNotesDBOperation(notebook: notebook)
        backendOperation = LoadNotesBackendOperation(notebook: notebook)
        
        addDependency(databaseOpearion)
        addDependency(backendOperation)
        
        let concurentQueue = OperationQueue()
        concurentQueue.addOperation(databaseOpearion)
        concurentQueue.addOperation(backendOperation)
    }
    
    override func main() {
        switch backendOperation.result!{
        case .failure(let error):
            print(error)
        case .success(let notes):
            notebook.copyNotes(notes: notes)
            OperationQueue().addOperation(SaveNoteDBOperation(notebook: notebook))
        }
        print("Load completed")
        uiComletion?()
        finish()
    }
}
