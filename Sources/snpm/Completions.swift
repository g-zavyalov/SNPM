//
//  Completions.swift
//  snpm
//
//  Created by Gleb Zavyalov on 19.01.2022.
//

import Files

func customCompletion(_ s: [String]) -> [String] {
    guard let directory = try? Folder(path: snippetsDirectory) else {
        print("Error: ".red + "\(snippetsDirectory) not found")
        return []
    }
    var snippetNames = Array<String>()
    for folder in directory.subfolders { snippetNames.append(folder.name.lowercased()) }

    if s.last == nil {
        return snippetNames
    } else {
        snippetNames.sort {
            return Snpm.distance(aStr: $0, bStr: s[0]) < Snpm.distance(aStr: $1, bStr: s[0])
        }
        return snippetNames
    }
}
