import UIKit
import CoreData

class FileNotebook{
    private(set) var notes: [Note] = []
    private var managedNotes = [ManagedNote]()
    
    public var backgroundContex: NSManagedObjectContext!
    
    public func add(_ note: Note){
        if !notes.contains(where: {$0.uid == note.uid}){
            notes.append(note)
            appendNoteToManagedObjects(note: note)
        }
    }
    
    public func remove(with uid: String){
        if let index = notes.firstIndex(where: {$0.uid == uid}){
            notes.remove(at: index)
            DispatchQueue.global().sync {
                let note = managedNotes.remove(at: index)
                backgroundContex.delete(note)
            }
        }
    }
    
    public func saveToFile(){
        var resultJson = [[String: Any]]()
        for note in notes{
            resultJson.append(note.json)
        }
        do{
            let data = try JSONSerialization.data(withJSONObject: resultJson, options: [])
            let fileManager = FileManager.default
            if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("notebook", isDirectory: false){
                fileManager.createFile(atPath: url.path , contents: data, attributes: nil)
            }else{
                return
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    public func loadFromFile(){
        let fileManager = FileManager.default
        if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("notebook", isDirectory: false){
            guard fileManager.fileExists(atPath: url.path) else {return}
            let data = fileManager.contents(atPath: url.path)
            notes = FileNotebook.parseFromJson(data: data!)
        }else{
            return
        }
    }
    
    public static func parseFromJson(data: Data) -> [Note]{
        do{
            var tempoNotes = [Note]()
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            for jsonNote in json{
                tempoNotes.append(Note.parse(json: jsonNote)!)
            }
            return tempoNotes
        }catch{
            print(error.localizedDescription)
            return [Note]()
        }
    }
    
    public func replaceNote(atIndex index: Int, with note: Note){
        guard index >= 0 && index < notes.count else {return}
        notes[index] = note
        
        let managedNote = managedNotes[index]
        managedNote.title = note.title
        managedNote.content = note.content
        managedNote.color = Int64(note.color.rgb)
        managedNote.uid = note.uid
        managedNote.importance = note.importance.rawValue
    }
    
    public func copyNotes(notes: [Note]){
        self.notes = notes
    }
}



/*
 Extension with coreData use
*/
extension FileNotebook{
    
    private func syncFromManagedObjects(){
        notes = []
        for managedNote in managedNotes{
            var importance: Note.Importance
            
            if managedNote.importance == "normal"{
                importance = .normal
            }
            else if managedNote.importance == "important"{
                importance = .important
            }
            else{
                importance = .nonimportant
            }
            let note = Note(title: managedNote.title ?? "",
                            content: managedNote.content ?? "",
                            importance: importance,
                            color: Int(managedNote.color).color,
                            uid: managedNote.uid ?? "")
            notes.append(note)
        }
    }
    
    private func appendNoteToManagedObjects(note: Note){
        let managedNote = ManagedNote(context: backgroundContex)
        managedNote.title = note.title
        managedNote.content = note.content
        managedNote.importance = note.importance.rawValue
        managedNote.color = Int64(note.color.rgb)
        managedNote.uid = note.uid
        
        managedNotes.append(managedNote)
    }
    
    public func loadFromDataBase(comletion: @escaping () -> ()){
        let fetchRequest: NSFetchRequest<ManagedNote> = NSFetchRequest(entityName: "ManagedNote")
        print(Thread.current)
        print("What??")
        backgroundContex.performAndWait {
            do{
                managedNotes = try backgroundContex.fetch(fetchRequest)
                syncFromManagedObjects()
                comletion()
            }catch{
                print(error)
            }
        }
    }
    
    public func saveToDataBase(comletion: @escaping () -> ()){
        sleep(2)
        backgroundContex.performAndWait {
            do{
                print("Thread!!!!!!!!!____________________ not main!!!")
                print(Thread.current)
                try backgroundContex.save()
                comletion()
            }catch{
                print("Save to CoreData error occured")
                print(error)
            }
            
        }
    }
}
