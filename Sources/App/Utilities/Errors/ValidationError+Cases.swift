//
//  ValidationError+Cases.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Validation

extension BasicValidationError {
    
    static let tokenMatchFailure = BasicValidationError("is not a valid Slack verification token.")
}
