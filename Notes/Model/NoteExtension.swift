import UIKit

extension UIColor{
    var rgb: Int{
        var result: Int = 0
        
        guard let rgb = self.cgColor.components else {return 0}
        guard rgb.count == 4 else {
            if rgb == [0,1] {return 0}
            if rgb == [1, 1] {return 0xFFFFFFFF}
            return 0
        } // blackColor components [0, 1]
        let (red, green, blue, alpha) = (Int(rgb[0] * 255), Int(rgb[1] * 255), Int(rgb[2] * 255), Int(rgb[3] * 255))
        result = result + (red << 24)
        result = result + (green << 16)
        result = result + (blue << 8)
        result += alpha
        return result
    }
}

extension Int{
    var color: UIColor{
        guard self >= 0 else {return UIColor.black}
        let red = (self & 0xFF000000) >> 24
        let green = (self & 0xFF0000) >> 16
        let blue = (self & 0xFF00) >> 8
        let alpha = (self & 0xFF)
        return UIColor(red: CGFloat(red) / 255,
                       green: CGFloat(green) / 255,
                       blue: CGFloat(blue) / 255,
                       alpha: CGFloat(alpha) / 255)
    }
}

extension Note{
    var json: [String: Any]{
        var json = [String: Any]()
        json["title"] = self.title
        json["content"] = self.content
        json["uid"] = self.uid
        if self.importance != .normal{
            json["importance"] = self.importance.rawValue
        }
        if self.color != UIColor.white{
            json["color"] = self.color.rgb
        }
        if self.selfDestructionDate != nil{
            json["date"] = selfDestructionDate?.timeIntervalSince1970
        }
        return json
    }
    
    static func parse(json: [String: Any]) -> Note?{
        let date: Date?
        let color: UIColor
        let importance: Importance
        
        guard   let title = json["title"] as? String,
            let content = json["content"] as? String,
            let uid = json["uid"] as? String
            else { return nil }
        
        if let timeSince1970 = json["date"] as? TimeInterval{
            date = Date(timeIntervalSince1970: timeSince1970)
        }else{
            date = nil
        }
        
        if let colorInt = json["color"] as? Int{
            color = colorInt.color
        }else{
            color = UIColor.white
        }
        
        if let importanceStr = json["importance"] as? String{
            if importanceStr == "important"{
                importance = .important
            }else{
                importance = .nonimportant
            }
        }else{
            importance = .normal
        }
        let note = Note(title: title,
                        content: content,
                        importance: importance,
                        color: color,
                        uid: uid,
                        date: date)
        return note
    }
}
