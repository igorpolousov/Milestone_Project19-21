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
    
    @IBOutlet var textView: UITextView!
    
    var notes: [Note]!
    var delegate: SendNoteToArray?
    var noteText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadNote()
//        textView.text = detailNotes[0].noteText
        
        textView.text = noteText
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNote()
        didUpdateDelegate()
        textView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func passData() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let whereToPass = storyBoard.instantiateViewController(withIdentifier: "Notes") as? NotesViewController  else { return }
        whereToPass.notes = notes
        show(whereToPass, sender: nil)
    }
    
    @objc func done() {
        saveNote()
        didUpdateDelegate()
        textView.endEditing(true)
    }
    
    func didUpdateDelegate() {
        delegate?.sendNote(notes)
    }
    
     func saveNote() {
         
         if let text = textView.text {
             let example = Note(noteTitle: text, noteText: text )
             notes.insert(example, at: 0)
             print(notes ?? "Oops")
             print(notes[0].noteText)
         }
         
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            defaults.setValue(savedData, forKey: "detailNotes")
        }
    }
    
    func loadNote() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "detailNotes") as? Data {
            do {
            notes = try jsonDecoder.decode([Note].self, from: savedData)
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? NotesViewController {
//            destination.notes = notes
//        }
//    }
    

}
