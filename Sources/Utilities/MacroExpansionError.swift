//
//  MacroExpansionError.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import Foundation
import SwiftDiagnostics

public struct MacroExpansionError: Error, CustomStringConvertible, DiagnosticMessage {
    public let message: String
    public let severity: DiagnosticSeverity
    public let diagnosticID: MessageID = MessageID(domain: "AnimatableMacro", id: "\(UUID().uuidString)")
    
    public init(message: String, severity: DiagnosticSeverity = .error) {
        self.message = message
        self.severity = severity
    }
    
    public var description: String { message }
    
}
