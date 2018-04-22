//
//  UserCommand.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

protocol UserCommand {
    
    /// This command will be envoked using this keyword
    static var keyword: String { get }
    
    /// User-friendly description used in the help dialog to describe the command
    static var description: String { get }
    
    /// This command is expected to have this number of words, excluding the command
    static var commandLength: CommandLength { get }
    
    /// Create this command with these words
    ///
    /// - Parameter contents: Additonal contents of the command
    init(contents: String?, request: UserCommandRequest) throws
    
    /// Create a future response as the result of this command
    ///
    /// - Parameter container: Container from which the command is running
    /// - Returns: Response seen by the user
    func reply(using container: Container) throws -> Future<Reply>
}
