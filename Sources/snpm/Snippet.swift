//
//  SnippetManager.swift
//  snpm
//
//  Created by Gleb Zavyalov on 02.01.2022.
//

import Foundation

enum SnippetHeader {
    static let defaultName = "Name:"
    static let defaultLink = "Link:"
    static let defaultDescription = "Description:"
}

struct Snippet {
    let name: String
    let description: String
    let link: String
    
    
    init(with name: String, description: String?, link: String?) {
        self.name = name
        self.description = description ?? ""
        self.link = link ?? ""
    }
    
    func toString() -> String {
        let output =
        SnippetHeader.defaultName.green + " " + name + "\n" +
        SnippetHeader.defaultDescription.green + " " + description + "\n" +
        SnippetHeader.defaultLink.green + " " + link + "\n"
        return output
    }
}
