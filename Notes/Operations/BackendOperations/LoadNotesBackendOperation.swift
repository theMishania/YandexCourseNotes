//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation{
    var result: LoadNotesBackendResult!
    let notebook: FileNotebook
    lazy var gistManager = NoteGistManager(notes: notebook.notes)

    init(notebook: FileNotebook){
        self.notebook = notebook
    }
    
    override func main() {
        gistManager.performLoadOperation { [unowned self] (loadResult) in
            self.result = loadResult
            self.finish()
        }
    }
}
