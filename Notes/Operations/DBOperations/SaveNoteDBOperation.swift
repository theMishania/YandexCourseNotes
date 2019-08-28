//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Мишаня  on 28/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class SaveNoteDBOperation: BaseDBOperation{
    override func main() {
        notebook.saveToDataBase {[unowned self] in
            print("saved")
            self.finish()
        }
    }
}
