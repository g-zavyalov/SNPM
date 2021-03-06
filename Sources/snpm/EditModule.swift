//
//  EditModule.swift
//  snpm
//
//  Created by Gleb Zavyalov on 02.01.2022.
//

import ArgumentParser
import Files
import ShellOut


extension SNPM {
    struct Edit: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Edit snippet")
        
        @Argument(help: "Snippet name", completion: .custom(customCompletion))
        var name: String
        
        
        mutating func run() {
            name = name.lowercased()
            
            guard let directory = try? Folder(path: snippetsDirectory) else {
                print("Error: ".red + "\(snippetsDirectory) not found")
                return
            }
            
            var snippetNames = Array<String>()
            for folder in directory.subfolders { snippetNames.append(folder.name.lowercased()) }
            
            snippetNames.sort {
                return distance(aStr: $0, bStr: name) < distance(aStr: $1, bStr: name)
            }
            
            if (snippetNames[0] != name) {
                print("\(name)".red + " doesn't exist")
                print("Possible variants: ")
                for i in 0..<snippetNames.count {
                    if (i == 5 && i != snippetNames.count) {
                        print("and \(snippetNames.count - i) more...")
                        break
                    }
                    print("\(snippetNames[i])".green)
                }
                return
            }
            
            guard let snippetFolder = try? directory.subfolder(named: name) else {
                print("Error: ".red + "Unable to access folder at \(snippetsDirectory)/\(name)")
                return
            }

            print("Path to configuration folder: " + "\(snippetFolder.path)" + Constants.snippetConfigurationFilename.green)
        }
    }
}
