//
//  ListModule.swift
//  snpm
//
//  Created by Gleb Zavyalov on 03.01.2022.
//

import ArgumentParser
import Files
import AppKit

extension Snpm {
    struct All: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "List of all snippets")
        
        mutating func run() {
            
            guard let directory = try? Folder(path: snippetsDirectory) else {
                print("Error: ".red + "\(snippetsDirectory) not found")
                return
            }
            
            var snippetNames = Array<String>()
            for folder in directory.subfolders { snippetNames.append(folder.name.lowercased()) }
            
            print("All snippets: ")
            for x in snippetNames {
                print("\(x)".green)
            }
            return
            
        }
        
    }
}
