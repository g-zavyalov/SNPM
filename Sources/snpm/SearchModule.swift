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
        
        
        
        @Flag(name: [.customLong("file"), .customShort("f")], help: "Paste as file")
        var file = false
        
        @Argument(help: "Snippet name", completion: .custom(customCompletion))
        var name: String
        
        @Argument(help: "Pick file", completion: .directory)
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
                return distance(aStr: $0, bStr: name) < distance(aStr: $1, bStr: name)
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
                    if (file) {
                        try Folder.current.createFile(named: files[id].name, contents: try files[id].read())
                        print("\(files[id].name)".green + " created!")
                        return
                    }
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
                
                print("Pick snippet (a - abort): ".yellow)
                let input = readLine()
                if input == nil || input?.count == 0 || input?.first == "a" {
                    print("Aborted!".yellow)
                    return
                }
                
                id = Int(input ?? "-1") ?? -1
                if (id != -1) {
                    if (file) {
                        try Folder.current.createFile(named: files[id].name, contents: try files[id].read())
                        print("\(files[id].name)".green + " created!")
                        return
                    }
                    let data = try files[id].readAsString()
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(data, forType: .string)
                    print("\(files[id].name)".green + " copied to clipboard!")
                    return
                }
            } catch {
                print(error)
            }
                
        }
        
    }
    
    public static func distance(aStr: String, bStr: String) -> Int {
        let a = Array(aStr)
        let b = Array(bStr)

        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append(Array(repeating: 0, count: b.count + 1))
        }

        for i in 1...a.count {
            dist[i][0] = i
        }
        
        for j in 1...b.count {
            dist[0][j] = j
        }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i - 1][j - 1]
                } else {
                    dist[i][j] = min(
                        dist[i - 1][j] + 1,
                        dist[i][j - 1] + 1,
                        dist[i - 1][j - 1] + 1
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }

}


