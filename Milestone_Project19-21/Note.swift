//
//  Note.swift
//  Milestone_Project19-21
//
//  Created by Igor Polousov on 07.12.2021.
//

import Foundation

class Note: Codable {
    var noteTitle: String
    var noteDate: String
    
    init(noteTitle: String, noteDate: String){
        self.noteTitle = noteTitle
        self.noteDate = noteDate
    }
}
