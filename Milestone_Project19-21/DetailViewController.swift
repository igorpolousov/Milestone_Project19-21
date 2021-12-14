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
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
}
