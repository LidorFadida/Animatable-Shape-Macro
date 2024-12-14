//
//  AnimatableIgnored.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import SwiftSyntax
import SwiftSyntaxMacros

///A placeholder macro that adds an annotation to a property without adding a single line of code.
///
///Used as a marker to ignore 'VectorArithmetic' operations.
public struct AnimatableIgnored: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        return []
    }
}

