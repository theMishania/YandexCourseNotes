//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation{
    let uid: String
    let notebook: FileNotebook
    var uiComletion: (() -> ())?
    
    init(uid: String, notebook: FileNotebook){
        self.uid = uid
        self.notebook = notebook
        super.init()
    }
    
    override func main() {
        
        let removeDBOperation = RemoveNoteDBOperation(uid: uid, notebook: notebook)
        let saveBackendOperation = SaveNotesBackendOperation(notebook: notebook)
        
        saveBackendOperation.addDependency(removeDBOperation)
        
        removeDBOperation.start()
        OperationQueue().addOperation(saveBackendOperation)

        uiComletion?()
        finish()
    }
}
