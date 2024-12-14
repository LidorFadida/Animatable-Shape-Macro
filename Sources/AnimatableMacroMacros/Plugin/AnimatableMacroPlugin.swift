//
//  AnimatableMacroPlugin.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AnimatableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AnimatableMacro.self,
        AnimatableIgnored.self
    ]
}
