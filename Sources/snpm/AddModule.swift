//
//  AddModule.swift
//  jobs
//
//  Created by Gleb Zavyalov on 02.01.2022.
//

import ArgumentParser
import Files

extension Snpm {
    struct Add: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Add file to snippet")
        
        @Argument(help: "Snippet name", completion: .custom(customCompletion))
        var name: String
        
        @Argument(help: "File name", completion: .directory)
        var fileName: String = ""
        
        mutating func run() {
            guard
                let file = try? Folder.current.file(at: fileName),
                let directory = try? Folder(path: snippetsDirectory),
                let snippetFolder = try? directory.subfolder(named: name)
            else {
                print("Error: ".red + "\(fileName) not found")
                return
            }
            
            do {
                let fileData = try file.read()
                try snippetFolder.createFile(named: fileName, contents: fileData)
            } catch {
                print(error)
                return
            }
            print("File added to snippet succefully!".green)
            print("Tip: ".yellow + "To edit snippet description write jobs edit \(name)")
        }
        
    }
}

