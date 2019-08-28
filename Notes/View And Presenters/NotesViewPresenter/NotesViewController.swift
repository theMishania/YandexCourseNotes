//
//  NotesViewController.swift
//  Notes
//
//  Created by Мишаня on 16/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

protocol NotesViewProtocol: class {
    func tableViewEndEditing()
    
    func presentViewController(_ viewController: UIViewController)
    func pushViewController(_ viewController: UIViewController)
    
    func updateTableView()
    func tableViewInsertRow(at indexPath: IndexPath)
    func tableViewUpdateRow(at indexPath: IndexPath)
    func tableViewDeleteRow(at indexPath: IndexPath)
}

class NotesViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let reuseID = "reusableCell"
    var presenter: NotesPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.requestTokenIfNeeded()
        setUpUI()
        setUpNavigationItem()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    private func setUpUI(){
        view.addSubview(tableView)
        tableView.rightAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.rightAnchor, multiplier: 0).isActive = true
        tableView.leftAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leftAnchor, multiplier: 0).isActive = true
        tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0).isActive = true
        tableView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        
        tableView.tableFooterView = UIView()//  чтобы табличка не имела пустых ячеек
        
    }
    private func setUpNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteDidTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleTableViewEditable))
    }
    
    @objc private func toggleTableViewEditable(){
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @objc func addNoteDidTapped() {
        presenter.addNoteDidTapped()
    }
    
}



extension NotesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.notesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
            cell!.detailTextLabel?.numberOfLines = 5
        }
        cell?.imageView?.image = createImage(with: presenter.getColorForNote(at: indexPath))
        cell!.textLabel?.text = presenter.getTitleForNote(at: indexPath)
        cell!.detailTextLabel?.text = presenter.getContentForNote(at: indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            presenter.removeNote(at: indexPath)
        }
    }
    
    private func createImage(with color: UIColor) -> UIImage{
        let size = CGSize(width: 40, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (contex) in
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            contex.cgContext.addEllipse(in: rect)
            color.setFill()
            contex.cgContext.drawPath(using: .fill)
        }
        return image
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(atIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension NotesViewController: NotesViewProtocol {
    func updateTableView() {
        tableView.reloadData()
    }
    
    func tableViewEndEditing() {
        tableView.isEditing = false
    }
    
    func tableViewInsertRow(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func tableViewUpdateRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableViewDeleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
