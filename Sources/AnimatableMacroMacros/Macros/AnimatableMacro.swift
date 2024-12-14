//
//  AnimatableMacro.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import Utilities

public struct AnimatableMacro: MemberMacro {
    
    private struct Constants {
        static let vectorName: String = "_AnimatableDataVector"
        static let shapeProtocol: String = "Shape"
        static let animatableIgnoredAnnotation: String = "@AnimatableIgnored"
        
        ///Error messages
        struct ErrorMessage {
            static let notAStruct: String = "@Animatable can only be applied to a struct"
            static let shapeConformance: String = "@Animatable can only be applied to structs that conform to the Shape protocol"
            static let somethingWentWrong: String = "Something went wrong"
            static let unexpectedPropertiesCount: String = "Unexpected property count encountered"
            static let redundantAnnotation: String = "The @Animatable macro has no effect here because no animatable properties have been found. Consider adding animatable properties to make the macro meaningful"
        }
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroExpansionError(message: Constants.ErrorMessage.notAStruct)
        }
        
        let inheritsShape = structDecl.inheritanceClause?.inheritedTypes.contains(where: { inheritedType in
            inheritedType.type.trimmedDescription == Constants.shapeProtocol//"Shape"
        }) ?? false

        guard inheritsShape else {
            throw MacroExpansionError(message: Constants.ErrorMessage.shapeConformance)
        }
        
        let animatableProperties: [AnimatableDeclProperty] = structDecl
            .memberBlock
            .members
            .compactMap { member in
                guard let varDecl = member.decl.as(VariableDeclSyntax.self),
                      let binding = varDecl.bindings.first,
                      let varPattern = binding.pattern.as(IdentifierPatternSyntax.self),
                      let type = binding.typeAnnotation?.type else {
                    return nil
                }
                return AnimatableDeclProperty(
                    name: varPattern.identifier.text,
                    typeSyntax: type,
                    attributes:  varDecl.attributes
                )
            }
            .filter { animatableDeclConfiguration in
                !animatableDeclConfiguration.attributesContains(trimmedDescription: Constants.animatableIgnoredAnnotation)
            }
        
        guard !animatableProperties.isEmpty else {
            context.diagnose(
                Diagnostic(
                    node: declaration,
                    message: MacroExpansionError(message: Constants.ErrorMessage.redundantAnnotation, severity: .warning)
                )
            )
            return []
        }
        
        switch animatableProperties.count {
            ///Single animatable property
        case 1:
            guard let animatableDeclConfiguration = animatableProperties.first else {
                throw MacroExpansionError(message: Constants.ErrorMessage.somethingWentWrong)
            }
            
            let animatableDataDecl = DeclSyntax(
            """
            var animatableData: \(animatableDeclConfiguration.typeSyntax) {
                get { self.\(raw: animatableDeclConfiguration.name) }
                set { self.\(raw: animatableDeclConfiguration.name) = newValue }
            }
            """
            )
            
            return [animatableDataDecl]
        case 2...:
            ///VectorArithmetic DeclSyntax
            let vectorArithmetic = try makeVectorArithmetic(animatableDecl: animatableProperties)
            ///animatableData DeclSyntax
            let properties = animatableProperties.map { $0.name }
            let animatableData = makeAnimatableData(vectorName: Constants.vectorName, properties: properties)
            
            return [vectorArithmetic, animatableData]
        default:
            throw MacroExpansionError(message: Constants.ErrorMessage.unexpectedPropertiesCount)
        }
        
    }

}

extension AnimatableMacro {

    private static func makeVectorArithmetic(animatableDecl: [AnimatableDeclProperty]) throws -> DeclSyntax {
        let animatableBuilder = AnimatableDeclBuilder(vectorName: Constants.vectorName)

        try animatableDecl.forEach { animatableDeclItem in
            let propertyName = animatableDeclItem.name
            let propertyTypeSyntax = animatableDeclItem.typeSyntax
            let shouldIgnoreProperty = animatableDeclItem
                .attributes
                .map { attribute in attribute.trimmedDescription }
                .reduce(into: []) { partialResult, element in partialResult.append(element) }
                .contains("@AnimatableIgnored")
            
            guard let typeTrimmedDescription = propertyTypeSyntax.as(IdentifierTypeSyntax.self)?.name.trimmedDescription else { throw MacroExpansionError(message: "Something went wrong") }

            if typeTrimmedDescription != "CGFloat" && typeTrimmedDescription != "Double" {
                if !shouldIgnoreProperty {
                    throw MacroExpansionError(
                        message: """
                                @AnimatableIgnored is required to ignore unsupported properties.
                                Currently supported types: 
                                'CGFloat', 'Double'
                                Annotate '\(propertyName)' with '@AnimatableIgnored' macro: 
                                '@AnimatableIgnored var \(propertyName): \(typeTrimmedDescription)'
                                """
                    )
                }
            }
            
            animatableBuilder
                .append(
                    structProperty: "var \(propertyName): \(propertyTypeSyntax)"
                )
                .append(
                    initializerArgumentProperty: "\(propertyName): \(propertyTypeSyntax)"
                )
                .append(
                    initializerBlockDeclarationLine: "self.\(propertyName) = \(propertyName)"
                )
                .append(
                    zeroPropertiesOperation: "\(propertyName): 0"
                )
                .append(
                    plusOperation: "\(propertyName): lhs.\(propertyName) + rhs.\(propertyName)"
                )
                .append(
                    minusOperation: "\(propertyName): lhs.\(propertyName) - rhs.\(propertyName)"
                )
                .append(
                    plusEqualsOperation: "lhs.\(propertyName) += rhs.\(propertyName)"
                )
                .append(
                    minusEqualsOperation: "lhs.\(propertyName) -= rhs.\(propertyName)"
                )
                .append(
                    scaleOperation: "self.\(propertyName) *= rhs"
                )
                .append(
                    magnitudeSquaredCalcOperation: "\(propertyName) * \(propertyName)"
                )
        }
        
        return animatableBuilder.buildDeclSyntaxExpression()
    }
    
    private static func makeAnimatableData(vectorName: String, properties: [String]) -> DeclSyntax {
        let get = "\(Constants.vectorName)(\(properties.map { "\($0): self.\($0)" }.joined(separator: ", ")))"
        let set = properties.map { "self.\($0) = newValue.\($0)" }.joined(separator: "\n")
        let animatableDataDecl = DeclSyntax(
        """
        var animatableData: \(raw: Constants.vectorName) {
            get { \(raw: get) }
            set { \(raw: set) }
        }
        """
        )
        return animatableDataDecl
    }
}
