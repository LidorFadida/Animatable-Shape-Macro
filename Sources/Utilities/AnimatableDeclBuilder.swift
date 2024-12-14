//
//  AnimatableDeclBuilder.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder

//TODO: - Add documentation
public class AnimatableDeclBuilder {
        
        private let vectorName: String
        
        private(set) var structPropertiesDeclaration: [String] = []
        
        private(set) var initializerArgumentsDeclaration: [String] = []
        
        private(set) var initializerBlockDeclaration: [String] = []
        
        private(set) var zeroPropertiesOperationDeclaration: [String] = []
        
        private(set) var plusOperationDeclaration: [String] = []
        
        private(set) var minusOperationDeclaration: [String] = []
        
        private(set) var plusEqualsOperationDeclaration: [String] = []
        
        private(set) var minusEqualsOperationDeclaration: [String] = []
        
        private(set) var scaleOperationDeclaration: [String] = []
        
        private(set) var magnitudeSquaredCalcOperationDeclaration: [String] = []
        
        public init(vectorName: String) {
            self.vectorName = vectorName
        }
        
        @discardableResult
        public func append(structProperty: String) -> Self {
            structPropertiesDeclaration.append(structProperty)
            return self
        }

        @discardableResult
        public func append(initializerArgumentProperty: String) -> Self {
            initializerArgumentsDeclaration.append(initializerArgumentProperty)
            return self
        }

        @discardableResult
        public func append(initializerBlockDeclarationLine: String) -> Self {
            initializerBlockDeclaration.append(initializerBlockDeclarationLine)
            return self
        }

        @discardableResult
        public func append(zeroPropertiesOperation: String) -> Self {
            zeroPropertiesOperationDeclaration.append(zeroPropertiesOperation)
            return self
        }

        @discardableResult
        public func append(plusOperation: String) -> Self {
            plusOperationDeclaration.append(plusOperation)
            return self
        }

        @discardableResult
        public func append(minusOperation: String) -> Self {
            minusOperationDeclaration.append(minusOperation)
            return self
        }

        @discardableResult
        public func append(plusEqualsOperation: String) -> Self {
            plusEqualsOperationDeclaration.append(plusEqualsOperation)
            return self
        }

        @discardableResult
        public func append(minusEqualsOperation: String) -> Self {
            minusEqualsOperationDeclaration.append(minusEqualsOperation)
            return self
        }

        @discardableResult
        public func append(scaleOperation: String) -> Self {
            scaleOperationDeclaration.append(scaleOperation)
            return self
        }

        @discardableResult
        public func append(magnitudeSquaredCalcOperation: String) -> Self {
            magnitudeSquaredCalcOperationDeclaration.append(magnitudeSquaredCalcOperation)
            return self
        }
        
        public func buildDeclSyntaxExpression() -> DeclSyntax {
            return AnimatableVectorDecl(
                vectorName: vectorName,
                structProperties: structPropertiesDeclaration.joined(separator: "\n"),
                initArguments: initializerArgumentsDeclaration.joined(separator: ", "),
                initBlock: initializerBlockDeclaration.joined(separator: "\n"),
                zeroProperties: zeroPropertiesOperationDeclaration.joined(separator: ", "),
                plusOperation: plusOperationDeclaration.joined(separator: ", "),
                minusOperation: minusOperationDeclaration.joined(separator: ", "),
                plusEqualsOperation: plusEqualsOperationDeclaration.joined(separator: "\n"),
                minusEqualsOperation: minusEqualsOperationDeclaration.joined(separator: "\n"),
                scaleOperation: scaleOperationDeclaration.joined(separator: "\n"),
                magnitudeSquaredCalc: magnitudeSquaredCalcOperationDeclaration.joined(separator: " + ")
            )
            .make()
        }

}
