//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation{
    let uid: String
    
    init(uid: String, notebook: FileNotebook) {
        self.uid = uid
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: uid)
        
        let saveOperation = SaveNoteDBOperation(notebook: notebook)
        OperationQueue().addOperation(saveOperation)
        
        finish()
    }
}
