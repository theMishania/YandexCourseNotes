//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Мишаня  on 29/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation{
    override func main() {
        notebook.loadFromDataBase {[unowned self] in
            print("Loaded from CoreData")
            self.finish()
        }
    }
}
