//
//  SentimentResponse.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor

struct SentimentResponse: Codable {
    
    var polarity: SentimentPolarity
    var subjectivity: SentimentSubjectivity
    var text: String
    var polarityConfidence: Double
    var subjectivityConfidence: Double
    
    enum CodingKeys: String, CodingKey {
        case polarity
        case subjectivity
        case text
        case polarityConfidence = "polarity_confidence"
        case subjectivityConfidence = "subjectivity_confidence"
    }
}

// MARK: - Extracted Values
extension SentimentResponse {
    
    var positivity: Double {
        return Double(polarity.polarity)
            * polarityConfidence
    }
    
    var objectivity: Double {
        return Double(subjectivity.polarity)
            * subjectivityConfidence
    }
}

// MARK: - Content
extension SentimentResponse: Content { }

enum SentimentPolarity: String, Codable {
    case positive, neutral, negative
    
    var polarity: Int {
        switch self {
        case .positive: return 1
        case .neutral: return 0
        case .negative: return -1
        }
    }
}

enum SentimentSubjectivity: String, Codable {
    case objective, subjective
    
    var polarity: Int {
        switch self {
        case .objective: return 1
        case .subjective: return -1
        }
    }
}
