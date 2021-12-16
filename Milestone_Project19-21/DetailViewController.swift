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
    var noteIndex: Int!
    var newNote: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My notes"
        print(newNote)
        print(noteIndex)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))]
        
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addingChangingNote()
        delegate?.sendNotes(notes: notes)
    }
    
    @objc func done() {
        addingChangingNote()
        textView.endEditing(true)
    }
    
    @objc func shareNote() {
        
    }
    
    @objc func deleteNote() {
        
    }
    
    @objc func addNote() {
        
    }
    func addingChangingNote() {
        if newNote {
            let example = Note(noteTitle: textView.text, noteDate: "")
            notes.append(example)
            save()
            print(notes[0].noteTitle)
            print(newNote)
            print(notes)
        } else {
            if let index = noteIndex {
            notes[index].noteTitle = textView.text
            save()
            }
        }
    }
    
    
    func save() {
        
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            defaults.setValue(savedData, forKey: "notes")
        }
        
    }
    
   
    
    @objc func keyboardAjustments() {
        
    }
    
}
