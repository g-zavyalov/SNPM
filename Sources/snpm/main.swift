import ArgumentParser
import Files

public enum Constants {
    static let toolName = "snpm"
    static let description = "Util for searching suitable snippet"
    static let version = "1.0.1"
    
    static let snippetConfigurationFilename = ".configuration.snpm"
}
public var snippetsDirectory = "~/.snippets"


struct Snpm: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: Constants.description,
        version: Constants.version,
        
        subcommands: [Find.self, New.self, Add.self, Edit.self, All.self],
        defaultSubcommand: Find.self
    )
}

Snpm.main()

