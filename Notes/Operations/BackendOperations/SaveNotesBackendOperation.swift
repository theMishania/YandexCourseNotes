//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

enum NetworkError {
    case unreachable
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var notebook: FileNotebook
    var result: SaveNotesBackendResult?
    lazy var backendGistManager = NoteGistManager(notes: notebook.notes)
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
    
    override func main() {
        backendGistManager.saveOperation = self
        backendGistManager.performSaveOperation{ [unowned self] (result) in
            print("saved to backend")
            self.result = result
            self.finish()
        }
        
    }
}
