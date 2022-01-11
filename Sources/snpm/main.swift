import ArgumentParser
import Files

public enum Constants {
    static let toolName = "snpm"
    static let description = "Utill for searching suitable snippet"
    static let version = "1.0.1"
    static let snippetConfigurationFilename = ".configuration.snpm"
}

public var snippetsDirectory = "~/.snippets"
func customCompletion(_ s: [String]) -> [String] {
    guard let directory = try? Folder(path: snippetsDirectory) else {
        print("Error: ".red + "\(snippetsDirectory) not found")
        return ["fff"]
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

struct Snpm: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: Constants.description,
        version: Constants.version,
        
        subcommands: [Search.self, New.self, Add.self, Edit.self, All.self],
        defaultSubcommand: Search.self
    )
}





//let directory = try? Folder(path: snippetsDirectory)
//var snippetNames = Array<String>()
//if let directory = directory {
//    for folder in (directory.subfolders) { snippetNames.append(folder.name.lowercased()) }
//}

Snpm.main()

