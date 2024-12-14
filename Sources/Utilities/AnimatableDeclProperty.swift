//
//  AnimatableDeclProperty.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

public struct AnimatableDeclProperty {
    public let name: String
    public let typeSyntax: TypeSyntax
    public let attributes: AttributeListSyntax
    
    
    public init(name: String, typeSyntax: TypeSyntax, attributes: AttributeListSyntax) {
        self.name = name
        self.typeSyntax = typeSyntax
        self.attributes = attributes
    }
    
    public func attributesContains(trimmedDescription: String) -> Bool {
        return !attributes
            .map { $0.trimmedDescription }
            .filter { $0 == trimmedDescription }
            .isEmpty
    }
}
