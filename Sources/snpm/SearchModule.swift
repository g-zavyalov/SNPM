//
//  SearchSnippet.swift
//  snpm
//
//  Created by Gleb Zavyalov on 02.01.2022.
//

import ArgumentParser
import Files
import AppKit

extension Snpm {
    struct Search: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Search for snippet")
        
        @Argument(help: "Snippet name")
        var name: String
        
        @Argument(help: "Pick file")
        var id: Int = -1
        
        mutating func run() {
            name = name.lowercased()
            
            guard let directory = try? Folder(path: snippetsDirectory) else {
                print("Error: ".red + "\(snippetsDirectory) not found")
                return
            }
            
            var snippetNames = Array<String>()
            for folder in directory.subfolders { snippetNames.append(folder.name.lowercased()) }
            
            snippetNames.sort {
                return SnippetSearchEngine.distance(aStr: $0, bStr: name) < SnippetSearchEngine.distance(aStr: $1, bStr: name)
            }
            
            if (snippetNames[0] != name) {
                print("\(name)".red + " doesn't exist")
                print("\nPossible variants: ")
                var i = 0
                for x in snippetNames {
                    print("\(x)".green)
                    i += 1
                    if (i == 5 && i != snippetNames.count) {
                        print("and \(snippetNames.count - i) more...")
                        break
                    }
                }
                return
            }
            
            // Snippet representation
            guard let snippetFolder = try? directory.subfolder(named: name) else {
                print("Error: ".red + "Unable to access folder at \(snippetsDirectory)/\(name)")
                return
            }
            
            guard let header = try? snippetFolder.file(named: Constants.snippetConfigurationFilename) else {
                print("Error: ".red + "Unable to access snippet specification")
                return
            }
            
            do {
                let headerData = try header.readAsString(encodedAs: .utf8)
                print(headerData)
                var files = Array<File>()
                for x in snippetFolder.files {
                    if (x.name == Constants.snippetConfigurationFilename) { continue }
                    files.append(x)
                    
                }
                if (id != -1) {
                    let data = try files[id].readAsString()
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(data, forType: .string)
                    print("\(files[id].name)".green + " copied to clipboard!")
                    return
                }
                
                var i = 0
                for x in files {
                    print("[\(i)]".yellow + " File:" + " \(x.name)".green)
                    var j = 1
                    let data = try x.readAsString()
                    let arr = data.split(separator: "\n")
                    for x in arr {
                        print(x)
                        j += 1
                        if (j == min(10, arr.count)) {
                            break
                        }
                    }
                    print("\n")
                    i += 1
                }
                
                print("Tip: ".yellow + "To copy snippet type " + "snpm <snippet-name> <number>".green)
            } catch {
                print(error)
            }
                
        }
        
    }
}

