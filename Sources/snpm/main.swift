import Files
import ArgumentParser

public enum Constants {
    static let toolName = "Snippet Manager"
    static let description = "Tool for managing your snippets"
    static let version = "1.0.1"
    
    static let snippetConfigurationFilename = ".configuration.snpm"
}
public var snippetsDirectory = "~/.snippets"


struct SNPM: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: Constants.description,
        version: Constants.version,
        
        subcommands: [Find.self, New.self, Add.self, Edit.self, All.self],
        defaultSubcommand: Find.self
    )
}

SNPM.main()

