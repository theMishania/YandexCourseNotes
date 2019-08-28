//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation{
    
    let notebook: FileNotebook
    
    init(notebook: FileNotebook){
        self.notebook = notebook
        super.init()
        print("saving init")
        let dbOperation = SaveNoteDBOperation(notebook: notebook)
        let backendOperation = SaveNotesBackendOperation(notebook: notebook)
        
        addDependency(dbOperation)
        addDependency(backendOperation)
        
        let concurentQueue = OperationQueue()
        concurentQueue.addOperation(dbOperation)
        concurentQueue.addOperation(backendOperation)
    }
    
    override func main() {
        print("Saved, saveOperation completed")
        print("Saved")
        finish()
    }
}
