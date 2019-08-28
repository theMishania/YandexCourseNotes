//
//  PhotoNotebook.swift
//  Notes
//
//  Created by Мишаня on 18/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

class PhotoNotebook{
    
    public  var images = [UIImage]()
    
    public  func addImage(_ image: UIImage){
        images.append(image)
        saveToFile()
    }
    
    public  func saveToFile(){
        let fileManager = FileManager()
        let directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("PhotoNotes")
        if !fileManager.fileExists(atPath: directoryURL.path){
            createDirectory(with: fileManager, atPath: directoryURL.path)
        }
        for (index, value) in images.enumerated(){
            save(value, ofIndex: index, toDirectory: directoryURL, with: fileManager)
        }
    }
    
    private func createDirectory(with fileManager: FileManager, atPath path: String){
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func save(_ image: UIImage, ofIndex index: Int, toDirectory directory: URL, with fileManager: FileManager){
        let fileURL = directory.appendingPathComponent(String(index))
        fileManager.createFile(atPath: fileURL.path, contents: image.jpegData(compressionQuality: 1), attributes: nil)
    }
    
    public  func loadFromFile(){
        let fileManager = FileManager()
        let directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("PhotoNotes")
        if fileManager.fileExists(atPath: directoryURL.path){
            do{
                let arrayOfFiles = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                guard !arrayOfFiles.isEmpty else {return}
                fillImagesWithContent(ofFiles: arrayOfFiles, with: fileManager)
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func fillImagesWithContent(ofFiles files: [URL], with fileManager: FileManager){
        let tempofiles = files.sorted(by: {Int($0.lastPathComponent)! <= Int($1.lastPathComponent)!})
        var tempoImages = [UIImage]()
        for file in tempofiles{
            if let image = UIImage(contentsOfFile: file.path){
                tempoImages.append(image)
            }
        }
        images = tempoImages
    }
    
    public  func getFilesCount() -> Int{
        var count = 0
        let fileManager = FileManager()
        let directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("PhotoNotes")
        do {
            let files = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            count = files.count
        } catch  {
            return 0
        }
        return count
    }
}
