//
//  BaseController.swift
//  App
//
//  Created by Chris Martin on 4/22/18.
//

import Vapor

class BaseController {
    
    // MARK: - Logging
    
    func log(error: Error, in request: Request, file: String = #file, function: String = #function, line: UInt = #line, column: UInt = #column) throws {
        
        try request.make(ConsoleLogger.self).log(
            error.localizedDescription,
            at: LogLevel.error,
            file: file,
            function: function,
            line: line,
            column: column
        )
    }
}
