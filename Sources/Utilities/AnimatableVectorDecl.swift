//
//  AnimatableVectorDecl.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import SwiftSyntax

public struct AnimatableVectorDecl {
    let vectorName: String
    let structProperties: String
    let initArguments: String
    let initBlock: String
    let zeroProperties: String
    let plusOperation: String
    let minusOperation: String
    let plusEqualsOperation: String
    let minusEqualsOperation: String
    let scaleOperation: String
    let magnitudeSquaredCalc: String
    
    func make() -> DeclSyntax {
        return DeclSyntax(
                """
                struct \(raw: vectorName): VectorArithmetic {
                    \(raw: structProperties)
                    
                    init(\(raw: initArguments)) {
                        \(raw: initBlock)
                    }
                    
                    static var zero: \(raw: vectorName) {
                        .init(\(raw: zeroProperties))
                    }
                    
                    static func + (lhs: \(raw: vectorName), rhs: \(raw: vectorName)) -> \(raw: vectorName) {
                        .init(\(raw: plusOperation))
                    }
                    
                    static func - (lhs: \(raw: vectorName), rhs: \(raw: vectorName)) -> \(raw: vectorName) {
                        .init(\(raw: minusOperation))
                    }
                    
                    static func += (lhs: inout \(raw: vectorName), rhs: \(raw: vectorName)) {
                        \(raw: plusEqualsOperation)
                    }
                    
                    static func -= (lhs: inout \(raw: vectorName), rhs: \(raw: vectorName)) {
                        \(raw: minusEqualsOperation)
                    }
                    
                    mutating func scale(by rhs: Double) {
                        \(raw: scaleOperation)
                    }
                    
                    var magnitudeSquared: Double {
                        return \(raw: magnitudeSquaredCalc)
                    }
                }
                """
        )
    }
}
