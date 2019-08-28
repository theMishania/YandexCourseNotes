//
//  PhotosViewController.swift
//  Notes
//
//  Created by Мишаня on 17/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

protocol PhotosViewProtocol: class {
    func imagesDidLoaded()
    func pushViewController(_ viewController: UIViewController)
    func presentViewController(_ viewController: UIViewController)
}

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: PhotosPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        presenter.makeBlankCells()
        presenter.loadImages()
    }
    
    private func createAddBarButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlertMenu))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func presentAlertMenu(){
        presenter.addPhotosDidTapped()
    }
}


extension PhotosViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  presenter.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotosViewCell
        
        cell.imageView.image = presenter.image(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = (view.frame.width - 20) / 3
        //print(view.frame.width, sideSize)
        let size = CGSize(width: sideSize, height: sideSize)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectImage(at: indexPath)
    }
    
}


extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            presenter.addImageToPhotoNotebook(image)
            self.collectionView.insertItems(at: [IndexPath(row: presenter.imagesCount - 1, section: 0)])
            dismiss(animated: true, completion: nil)
        }
    }
}


extension PhotosViewController: PhotosViewProtocol {
    
    func imagesDidLoaded() {
        self.collectionView.reloadData()
        self.createAddBarButton()
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
   
}

