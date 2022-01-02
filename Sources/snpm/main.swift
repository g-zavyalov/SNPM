import ArgumentParser
import Files

public enum Constants {
    static let toolName = "snpm"
    static let description = "Utill for searching suitable snippet"
    static let version = "1.0.a"
    static let snippetConfigurationFilename = ".configuration.snpm"
}

public var snippetsDirectory = "~/.snippets"


struct Snpm: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: Constants.description,
        version: Constants.version,
        
        subcommands: [Search.self, New.self, Add.self, Edit.self],
        defaultSubcommand: Search.self
    )
}



Snpm.main()
