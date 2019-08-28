//
//  NoteGistManager.swift
//  Notes
//
//  Created by Мишаня  on 11/08/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

class NoteGistManager{
    
    private let gitHubApi = "https://api.github.com/gists"
    private let yandexFileName = "ios-course-notes-db"
    private let notes: [Note]
    private var first = true
    
    public var saveOperation: SaveNotesBackendOperation!
    
    init(notes: [Note]) {
        self.notes = notes
    }
    
    public func performSaveOperation(comletion: @escaping (SaveNotesBackendResult) -> ()){
        guard let token = UserDefaults.standard.object(forKey: "accessToken") as? String else{
            comletion(.failure(.unreachable))
            return
        }
        if let gistId = UserDefaults.standard.object(forKey: "gistId") as? String{
            let components = URLComponents(string: gitHubApi + "/\(gistId)")
            guard let url = components?.url else {comletion(.failure(.unreachable));return}
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
            
            var tempoJSON = [[String: Any]]()
            for note in notes{
                tempoJSON.append(note.json)
            }
            var content = String(data: try! JSONSerialization.data(withJSONObject: tempoJSON, options: []), encoding: .utf8)
            if notes.isEmpty{
                content = "No notes"
            }
            let gistFiles = [yandexFileName: GistFile(filename: yandexFileName, rawUrl: nil, content: content!)]
            
            let gist = Gist(files: gistFiles, isPublic: nil, id: nil)
            
            request.httpBody = try! JSONEncoder().encode(gist)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    comletion(.failure(.unreachable))
                }
                comletion(.success)
            }
            task.resume()
            
        }else{
            print("No gistId")
            createGist(withToken: token, comletion: comletion)
        }
    }
    
    private func createGist(withToken token: String, comletion: @escaping (SaveNotesBackendResult) -> ()){
        let gistFiles = [yandexFileName: GistFile(filename: yandexFileName, rawUrl: nil, content: "No notes yet")]
        let gist = Gist(files: gistFiles, isPublic: false, id: nil)
        
        let components = URLComponents(string: gitHubApi)
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        do {
            request.httpBody = try JSONEncoder().encode(gist)
        } catch  {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) {[unowned self] (data, response, error) in
            guard let data = data else {return}
            do{
                let gist = try JSONDecoder().decode(Gist.self, from: data)
                UserDefaults.standard.set(gist.id, forKey: "gistId")
                if self.first{
                    self.performSaveOperation(comletion: comletion)
                    self.first = false
                }
            }catch{
                print(error)
                return
            }
            
//            for gistFile in gist.files{
//                if gistFile.key == "ios-course-notes-db"{
//                    UserDefaults.standard.set(gistFile.value, forKey: "backendRawUrl")
//                }
//            }
            
        }
        task.resume()
        
    }
    
    private func getRawURLForBackend(withGistId gistID: String, comletion: @escaping (String?) -> ()){
        let components = URLComponents(string: gitHubApi + "/" + gistID)
        guard let url = components?.url else {return}
        
        let task = URLSession.shared.dataTask(with: url) {[unowned self] (data, response, error) in
            guard error != nil else {comletion(nil); return}
            guard let data = data else {comletion(nil); return}
            do{
                let gist = try JSONDecoder().decode(Gist.self, from: data)
                guard let files = gist.files else {comletion(nil); return}
                for file in files{
                    if file.key == self.yandexFileName{
                        guard let rawURL = file.value.rawUrl else {comletion(nil); return}
                        comletion(rawURL)
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    public func performLoadOperation(comletion: @escaping (LoadNotesBackendResult) -> ()){
        if let gistId = UserDefaults.standard.object(forKey: "gistId") as? String{
            getRawURLForBackend(withGistId: gistId) { (rawURL) in
                guard let rawURL = rawURL else {comletion(.failure(.unreachable));return}
                let task = URLSession.shared.dataTask(with: URL(string: rawURL)!, completionHandler: { (data, response, error) in
                    if let error = error{
                        print(error)
                        comletion(.failure(.unreachable))
                        return
                    }
                    let response = response as! HTTPURLResponse
                    if response.statusCode > 300{
                        comletion(.failure(.unreachable))
                        return
                    }
                    guard let data = data else {comletion(.success([Note]()));return}
                    let notes = FileNotebook.parseFromJson(data: data)
                    comletion(.success(notes))
                })
                task.resume()
            }
        }else{
            comletion(.failure(.unreachable))
        }
    }
    
    
}
