//
//  PhotosPresenter.swift
//  Notes
//
//  Created by Мишаня on 26/08/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

protocol PhotosPresenterProtocol: class {
    var imagesCount: Int { get }
    func loadImages()
    func makeBlankCells()
    func didSelectImage(at indexPath: IndexPath)
    func image(at indexPath: IndexPath) -> UIImage
    func addPhotosDidTapped()
    func addImageToPhotoNotebook(_ image: UIImage)
}

class PhotosPresenter {
    unowned var view: PhotosViewProtocol
    private var imagesIsLoaded = false
    
    private var photoNotebook: PhotoNotebook = PhotoNotebook()
    
    init(view: PhotosViewProtocol) {
        self.view = view
    }
    
    private func createImagesArray(ofCount count: Int) -> [UIImage]{
        guard count >= 0 else {return [UIImage]()}
        var resultArray = [UIImage]()
        for _ in 0..<count{
            let image = createImage()
            resultArray.append(image)
        }
        return resultArray
    }
    
    private func createImage() -> UIImage{
        let size = CGSize(width: 20, height: 20)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (context)  in
            UIColor.lightGray.setFill()
            context.cgContext.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            context.cgContext.drawPath(using: .fill)
        }
        return image
    }
}

extension PhotosPresenter: PhotosPresenterProtocol {
    
    var imagesCount: Int {
        return photoNotebook.images.count
    }
    
    func loadImages() {
        DispatchQueue.global().async {
            self.photoNotebook.loadFromFile()
            DispatchQueue.main.sync {
                self.imagesIsLoaded = true
                self.view.imagesDidLoaded()
            }
        }

    }
    
    func makeBlankCells() {
        photoNotebook.images = createImagesArray(ofCount: photoNotebook.getFilesCount())
    }
    
    func didSelectImage(at indexPath: IndexPath) {
        if imagesIsLoaded{
            let index = indexPath.row
            let previewVC = PreviewViewController(images: photoNotebook.images, indexOffset: index)
            view.pushViewController(previewVC)
        }
    }
    
    func image(at indexPath: IndexPath) -> UIImage {
        return photoNotebook.images[indexPath.row]
    }
    
    func addPhotosDidTapped() {
        let alertController = UIAlertController(title: nil, message: "Выберите фото", preferredStyle: .actionSheet)
        let photoLibraryAction = createLibraryAlertAction()
        let cameraAction = createCameraAlertAction()
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        view.presentViewController(alertController)
    }
    
    private func createCameraAlertAction() -> UIAlertAction{
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = (self.view as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                self.view.presentViewController(imagePicker)
            }
        }
        return cameraAction
    }
    
    private func createLibraryAlertAction() -> UIAlertAction{
        let photoLibraryAction = UIAlertAction(title: "Галерея", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = (self.view as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                self.view.presentViewController(imagePicker)
            }
        }
        return photoLibraryAction
    }
    
    func addImageToPhotoNotebook(_ image: UIImage) {
        photoNotebook.addImage(image)
    }
}
