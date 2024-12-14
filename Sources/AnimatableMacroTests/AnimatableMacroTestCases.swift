//
//  AnimatableMacroTestCases.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 13/12/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacrosTestSupport
import Testing
import MacroTesting
#if canImport(AnimatableMacro)
import AnimatableMacroMacros
#endif

@Suite
struct AnimatableMacroTestCases {
    //MARK: - Errors
    @Test("Error Shape Conformance Missing")
    func testAnimatableMacroErrorForStructWithoutShapeConformance() throws {
        assertMacro(["Animatable" : AnimatableMacro.self]) {
            """
            @Animatable
            struct MissingShapeConformance {
                var myValue: CGFloat
                func path(in rect: CGRect) -> Path { Path() }   
            }
            """
        } diagnostics: {
            """
            @Animatable
            ┬──────────
            ╰─ 🛑 @Animatable can only be applied to structs that conform to the Shape protocol
            struct MissingShapeConformance {
                var myValue: CGFloat
                func path(in rect: CGRect) -> Path { Path() }   
            }
            """
        }
    }
    
    @Test("Error Class Declaration")
    func testAnimatableMacroErrorClassDeclaration() throws {
        assertMacro(["Animatable" : AnimatableMacro.self]) {
            """
            @Animatable
            class ClassDeclaration: Shape {
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        } diagnostics: {
            """
            @Animatable
            ┬──────────
            ╰─ 🛑 @Animatable can only be applied to a struct
            class ClassDeclaration: Shape {
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        }
    }
    
    @Test("Error Property Declaration")
    func testAnimatableMacroErrorPropertyDeclaration() throws {
        assertMacro(["Animatable" : AnimatableMacro.self]) {
            """
            @Animatable
            struct UnsupportedPropertyDeclaration: Shape {
                var float: CGFloat
                var integer: Int
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        } diagnostics: {
            """
            @Animatable
            ┬──────────
            ╰─ 🛑 @AnimatableIgnored is required to ignore unsupported properties.
            Currently supported types: 
            'CGFloat', 'Double'
            Annotate 'integer' with '@AnimatableIgnored' macro: 
            '@AnimatableIgnored var integer: Int'
            struct UnsupportedPropertyDeclaration: Shape {
                var float: CGFloat
                var integer: Int
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        }
    }
    
    //MARK: - Warnings
    @Test("Warning Redundant Usage")
    func testAnimatableMacroWarningForStructWithoutStoredProperties() throws {
        assertMacro(["Animatable" : AnimatableMacro.self]) {
            """
            @Animatable
            struct SingleValueShape: Shape {
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        } diagnostics: {
            """
            @Animatable
            ╰─ ⚠️ The @Animatable macro has no effect here because no animatable properties have been found. Consider adding animatable properties to make the macro meaningful
            struct SingleValueShape: Shape {
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        } expansion: {
            """
            struct SingleValueShape: Shape {
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        }
    }
    
    //MARK: - Success
    @Test("Success AnimatableIgnored() Property Declaration")
    func testAnimatableMacroSuccessAnimatableIgnoredPropertyDeclaration() throws {
        assertMacro(
            [
                "Animatable" : AnimatableMacro.self,
                "AnimatableIgnored" : AnimatableIgnored.self
            ]) {
            """
            @Animatable
            struct MultipleValuesShape: Shape {
                var float: CGFloat
                @AnimatableIgnored 
                var integer: Int
                func path(in rect: CGRect) -> Path { Path() }
            } 
            """
        } expansion: {
            """
            struct MultipleValuesShape: Shape {
                var float: CGFloat

                var integer: Int
                func path(in rect: CGRect) -> Path { Path() }

                var animatableData: CGFloat {
                    get {
                        self.float
                    }
                    set {
                        self.float = newValue
                    }
                }
            } 
            """
        }
    }
    
    @Test("Success Single Property")
    func testAnimatableMacroSuccessForSingleProperty() throws {
        assertMacro(["Animatable" : AnimatableMacro.self]) {
            """
            @Animatable
            struct SingleValueShape: Shape {
                var myValue: CGFloat
                func path(in rect: CGRect) -> Path { Path() }   
            }
            """
        } expansion: {
            """
            struct SingleValueShape: Shape {
                var myValue: CGFloat
                func path(in rect: CGRect) -> Path { Path() }   

                var animatableData: CGFloat {
                    get {
                        self.myValue
                    }
                    set {
                        self.myValue = newValue
                    }
                }
            }
            """
        }
    }
    
    @Test("Success Multiple Properties")
    func testAnimatableMacroSuccessForMultipleProperties() throws {
        assertMacro(["Animatable" : AnimatableMacro.self]) {
            """
            @Animatable
            struct MultipleValuesShape: Shape {
                var myValue: CGFloat
                var hisValue: CGFloat
                func path(in rect: CGRect) -> Path { Path() }   
            }
            """
        } expansion: {
            """
            struct MultipleValuesShape: Shape {
                var myValue: CGFloat
                var hisValue: CGFloat
                func path(in rect: CGRect) -> Path { Path() }   

                struct _AnimatableDataVector: VectorArithmetic {
                    var myValue: CGFloat
                    var hisValue: CGFloat

                    init(myValue: CGFloat, hisValue: CGFloat) {
                        self.myValue = myValue
                        self.hisValue = hisValue
                    }

                    static var zero: _AnimatableDataVector {
                        .init(myValue: 0, hisValue: 0)
                    }

                    static func + (lhs: _AnimatableDataVector, rhs: _AnimatableDataVector) -> _AnimatableDataVector {
                        .init(myValue: lhs.myValue + rhs.myValue, hisValue: lhs.hisValue + rhs.hisValue)
                    }

                    static func - (lhs: _AnimatableDataVector, rhs: _AnimatableDataVector) -> _AnimatableDataVector {
                        .init(myValue: lhs.myValue - rhs.myValue, hisValue: lhs.hisValue - rhs.hisValue)
                    }

                    static func += (lhs: inout _AnimatableDataVector, rhs: _AnimatableDataVector) {
                        lhs.myValue += rhs.myValue
                        lhs.hisValue += rhs.hisValue
                    }

                    static func -= (lhs: inout _AnimatableDataVector, rhs: _AnimatableDataVector) {
                        lhs.myValue -= rhs.myValue
                        lhs.hisValue -= rhs.hisValue
                    }

                    mutating func scale(by rhs: Double) {
                        self.myValue *= rhs
                        self.hisValue *= rhs
                    }

                    var magnitudeSquared: Double {
                        return myValue * myValue + hisValue * hisValue
                    }
                }

                var animatableData: _AnimatableDataVector {
                    get {
                        _AnimatableDataVector(myValue: self.myValue, hisValue: self.hisValue)
                    }
                    set {
                        self.myValue = newValue.myValue
                        self.hisValue = newValue.hisValue
                    }
                }
            }
            """
        }
    }
    
}
