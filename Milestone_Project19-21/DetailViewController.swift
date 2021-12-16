//
//  DetailViewController.swift
//  Milestone_Project19-21
//
//  Created by Igor Polousov on 07.12.2021.
//

import UIKit


protocol SendNoteToArray {
    func sendNote(_ notes: [Note] )
}

class DetailViewController: UIViewController {
    
    var deleteButton: UIBarButtonItem!
    var newNoteButton: UIBarButtonItem!
    var noteIndex: Int!

    @IBOutlet var textView: UITextView!
    var newsNote: Bool!
    var deletedNote: Bool = false
    
    var notesSend: [Note]!
    var delegate: SendNoteToArray?
    var noteText: String!
    var originalText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNote()
        
        
        textView.text = noteText
        originalText = noteText
        
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.toolbar.tintColor = .systemOrange
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        navigationController?.navigationBar.tintColor = .systemOrange
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeNote))
       
        newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNote))
       
        
        toolbarItems = [deleteButton,space,newNoteButton]
        navigationController?.isToolbarHidden = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        savesNotes()
        saveNote()
        didUpdateDelegate()
        textView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    

    @objc func newNote() {
        saveNote()
        newsNote = true
        didUpdateDelegate()
        noteIndex = nil
        textView.text = ""
        
        
    }
    
    @objc func done() {
        savesNotes()
        saveNote()
        didUpdateDelegate()
        textView.endEditing(true)
    }
    
    @objc func removeNote() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = deleteButton
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _Arg in
            self?.removesNote()
            self?.textView.text = ""
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac,animated: true)
    }
    
    func removesNote() {
        deletedNote = true
        notesSend.remove(at: noteIndex)
        if notesSend.count == 0 {
            noteIndex = nil
        }
        delegate?.sendNote(notesSend)

    }
    
    func didUpdateDelegate() {
        delegate?.sendNote(notesSend)
    }
    
    func savesNotes() {
        if !deletedNote {
            if textView.text != "" && newsNote {
                let example = Note(noteTitle: textView.text, noteText: "")
                notesSend.append(example)
                print(notesSend)
            }
            
            guard noteIndex != nil else { return }
            if textView.text != originalText {
                if let text = textView.text {
                    if let index = noteIndex {
                        notesSend[index].noteTitle = text
                        print(notesSend[index].noteTitle)
                    }
                }
            }
        }
    }
    
    func saveNote() {
 
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notesSend) {
            defaults.setValue(savedData, forKey: "detailNotes")
        }
    }
    
    func loadNote() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "detailNotes") as? Data {
            do {
            notesSend = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("No data available fo load")
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
        
    }


}
