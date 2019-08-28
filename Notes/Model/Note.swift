import UIKit

public struct Note{
    
    enum Importance: String{
        case important  = "important"
        case normal = "normal"
        case nonimportant = "nonimportant"
    }
    let title: String
    let content: String
    let uid: String
    let importance: Importance
    let color: UIColor
    let selfDestructionDate: Date?
    
    init(title: String,
         content: String,
         importance: Importance,
         color: UIColor = .white,
         uid: String = UUID().uuidString,
         date: Date? = nil) {
        self.title = title
        self.content = content
        self.importance = importance
        self.uid = uid
        self.color = color
        selfDestructionDate = date
    }
}

