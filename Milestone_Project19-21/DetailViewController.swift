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
        navigationController?.toolbar.tintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .systemOrange
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let addNewNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [trashButton,space, addNewNote]
        navigationController?.isToolbarHidden = false
        
        textView.text = noteText
        if let index = noteIndex {
            originalText = notes[index].noteTitle
        }
    }
    
    @objc func deleteNote() {
        
    }
    
    @objc func addNote() {
        
    }
    
}
