//
//  NotesViewController.swift
//  Milestone_Project19-21
//
//  Created by Igor Polousov on 07.12.2021.
//

import UIKit

class NotesViewController: UITableViewController, SendNoteToArray {
    
    var notesGet = [Note]()
    var newNoteButton: UIBarButtonItem!
    var notesCountInfo: UIBarButtonItem!
    
     var notesCount = 0 {
        didSet {
            notesCountInfo?.title = "\(notesCount) Notes"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        print(notesGet)
        
        notesCount = notesGet.count
        
        title = "Notes"
        navigationController?.toolbar.tintColor = .systemOrange
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        
        notesCountInfo = UIBarButtonItem(title: "\(notesGet.count) Notes", image: nil, primaryAction: nil, menu: nil)
        
        toolbarItems = [space, notesCountInfo, space, newNoteButton]
        navigationController?.isToolbarHidden = false


    }

    
    @objc func addNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.delegate = self
            vc.notesSend = notesGet
            vc.newsNote = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadNotes() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "detailNotes") as? Data {
            do {
                notesGet = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("There's no data to load")
            }
        }
    }
    
    func saveNotes() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notesGet) {
            defaults.setValue(savedData, forKeyPath: "detailNotes")
        }
    }
    
    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesCount = notesGet.count
        return  notesGet.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = notesGet[indexPath.row].noteTitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.noteText = notesGet[indexPath.row].noteTitle
            vc.noteIndex = indexPath.row
            vc.delegate = self
            vc.notesSend = notesGet
            vc.newsNote = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesGet.remove(at: indexPath.row)
            notesCount = notesGet.count
            saveNotes()
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func sendNote(_ notes: [Note]) {
        self.notesGet = notes
    }
    


}
