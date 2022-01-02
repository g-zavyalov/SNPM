import ArgumentParser
import Files

public enum Constants {
    static let toolName = "snpm"
    static let description = "Utillity for searching suitable snippet"
    static let version = "alpha 0.0.1"
    static let snippetsDirectory = "~/.snippets"

}

struct Snpm: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: Constants.description,
        version: Constants.version,
        
        subcommands: [New.self, Search.self, Edit.self, Add.self],
        defaultSubcommand: Search.self
    )
}



Snpm.main()
