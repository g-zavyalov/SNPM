//
//  NewSnippet.swift
//  jobs
//
//  Created by Gleb Zavyalov on 02.01.2022.
//

import ArgumentParser
import Files

extension Snpm {
    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Create new snippet")
        
        @Argument(help: "Snippet name")
        var name: String
        
        @Argument(help: "File name", completion: .directory)
        var fileName: String = ""
        
        mutating func run() {
            guard let file = try? Folder.current.file(at: fileName) else {
                print("Error: ".red + "\(fileName) not found")
                return
            }
            guard let directory = try? Folder(path: snippetsDirectory) else {
                print("Error: ".red + "\(snippetsDirectory) not found")
                return
            }
            
            guard let snippetFolder = try? directory.createSubfolder(named: name) else {
                print("Error: ".red + "Unable to create subfolder at \(snippetsDirectory)")
                return
            }
            
            do {
                let fileData = try file.read()
                try snippetFolder.createFile(named: Constants.snippetConfigurationFilename, contents: Snippet(with: name, description: nil, link: nil).toString().data(using: .utf8))
                try snippetFolder.createFile(named: fileName, contents: fileData)
            } catch {
                print(error)
                return
            }
            print("Snippet created succefully!".green)
            print("Tip: ".yellow + "To specify snippet write snpm edit \(name)")
        }
        
    }
}
