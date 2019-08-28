//
//  BaseDBOperation.swift
//  Notes
//
//  Created by Мишаня  on 28/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class BaseDBOperation: AsyncOperation{
    let notebook: FileNotebook
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
}
