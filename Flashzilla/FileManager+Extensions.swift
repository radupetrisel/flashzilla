//
//  FileManager-DocumentsDir.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 27.07.2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        Self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static var cardsJson: URL {
        documentsDirectory.appending(path: "cards.json")
    }
}
