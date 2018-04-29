//
//  ClientRequest.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor

protocol ClientRequest {
    
    static var method: HTTPMethod { get }
    static var headers: HTTPHeaders { get }
    static var destination: URLRepresentable { get }
}

protocol ContentClientRequest: ClientRequest, Content { }

extension ContentClientRequest {
    
    static var defaultMediaType: MediaType {
        
        switch method {
        case .GET, .DELETE: return .urlEncodedForm
        default: return .json
        }
    }
}

extension ClientRequest {
    
    static var headers: HTTPHeaders {
        return [:]
    }
}

extension Client {
    
    func send<Request: ContentClientRequest>(request: Request) throws -> Future<Response> {
        
        switch Request.defaultMediaType {
        case .urlEncodedForm:
            let url = try createEncodedURL(using: Request.destination, content: request)
            return send(Request.method, headers: Request.headers, to: url)
            
        default:
            return send(
                Request.method,
                headers: Request.headers,
                to: Request.destination,
                content: request
            )
        }
    }
    
    private func createEncodedURL<C: Content>(using baseURL: URLRepresentable, content: C) throws -> URLRepresentable {
        
        let encoder = FormURLEncoder()
        let data = try encoder.encode(content)
        let params = try String(data: data, encoding: .utf8).unwrapped()
        
        return "\(baseURL)?\(params)"
    }
}
