//
//  DetailViewController.swift
//  Milestone_Project19-21
//
//  Created by Igor Polousov on 07.12.2021.
//

import UIKit

protocol SendNotesDelegate {
    func sendNotes(notes: [Note])
}

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    var notes = [Note]()
    var delegate: SendNotesDelegate?
    
    var noteText: String!
    var originalText: String!
    var noteIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationController?.toolbar.tintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .systemOrange
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let addNewNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [trashButton,space, addNewNote]
        navigationController?.isToolbarHidden = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardAjustments), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardAjustments), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        
        textView.text = noteText
        if let index = noteIndex {
            originalText = notes[index].noteTitle
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func done() {
        
    }
    
    @objc func deleteNote() {
        
    }
    
    @objc func addNote() {
        
    }
    
    func updateDelegate() {
        self.delegate?.sendNotes(notes: notes)
    }
    
    func save() {
        
    }
    
    func load() {
        
    }
    
    @objc func keyboardAjustments() {
        
    }
    
}
