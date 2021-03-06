//
//  CreateNotebookViewController.swift
//  Everpobre
//
//  Created by Javi on 24/3/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import CoreData

protocol NotebookModalViewControllerDelegate {
    func didAddNotebook(notebook: Notebook)
    func didEditNotebook(notebook: Notebook)
}

class NotebookModalViewController: UIViewController {
    
    
    var notebook: Notebook? {
        didSet {
            nameTextView.text = notebook?.name
            guard let date = notebook?.created else { return }
            dateTextView.date = date as Date
            
        }
    }
    
    var delegate: NotebookModalViewControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints  = false
        return textView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let dateTextView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints  = false
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUIStyle()
        
        setupCancelNavigation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = notebook == nil ? "Create notebook" : "Edit notebook"
    }
    
    private func setupUIStyle(){
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel,nameTextView])
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateStackView = UIStackView(arrangedSubviews: [dateLabel,dateTextView])
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let containerStackView = UIStackView(arrangedSubviews: [nameStackView,dateStackView])
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = UILayoutConstraintAxis.vertical
        containerStackView.backgroundColor = UIColor.yellow
        
        view.addSubview(containerStackView)
        
        containerStackView.addSubview(nameStackView)
        containerStackView.addSubview(dateStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.heightAnchor.constraint(equalToConstant: 250),
            
            nameStackView.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            nameStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            nameStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            nameStackView.heightAnchor.constraint(equalToConstant: 50),
            
//            nameLabel.leadingAnchor.constraint(equalTo: nameStackView.leadingAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            dateStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            dateStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            dateStackView.heightAnchor.constraint(equalToConstant: 50),

//            dateLabel.leftAnchor.constraint(equalTo: dateStackView.leftAnchor, constant: 15),
            dateLabel.widthAnchor.constraint(equalToConstant: 100)
        ])

    }
    
    @objc func handleSave(){
        if notebook == nil {
            CreateNotebook()
        }else{
            saveNotebookChanges()
        }
    }
    
    private func CreateNotebook(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let notebook = Notebook(context: context)
        
        notebook.setValue(nameTextView.text, forKey: "name")
        notebook.setValue(dateTextView.date, forKey: "created")
        
        
        do{
            try context.save()
            dismiss(animated: true, completion: nil)
//            dismiss(animated: true){
//                self.delegate?.didAddNotebook(notebook: notebook as! Notebook)
//            }
        } catch let saveErr {
            print("Failed to save notebook:", saveErr)
        }
    }
    
    private func saveNotebookChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        notebook?.name = nameTextView.text
        notebook?.created = dateTextView.date as NSDate
        
        do{
            try context.save()
            
            dismiss(animated: true){
                self.delegate?.didEditNotebook(notebook: self.notebook!)
            }
        } catch let saveErr {
            print("Failed to save notebook:", saveErr)
        }
    }
    
}
