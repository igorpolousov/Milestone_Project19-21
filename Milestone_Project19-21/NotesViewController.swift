//
//  NotesViewController.swift
//  Milestone_Project19-21
//
//  Created by Igor Polousov on 07.12.2021.
//

import UIKit

class NotesViewController: UITableViewController, SendNotesDelegate {
    
    var notes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNewNote))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [space,newNoteButton]
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.toolbar.tintColor = .systemOrange
        
        load()
        print(notes)
    }

    @objc func addNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.notes = notes
            vc.delegate = self
            vc.newNote = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func sendNotes(notes: [Note]) {
        self.notes = notes
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = notes[indexPath.row].noteTitle
        cell.detailTextLabel?.text = notes[indexPath.row].noteDate

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.newNote = false
            vc.noteIndex = indexPath.row
            vc.noteText = notes[indexPath.row].noteTitle
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    func load() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "notes") as? Data {
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                print("Unable to load data")
            }
        }
    }

}
