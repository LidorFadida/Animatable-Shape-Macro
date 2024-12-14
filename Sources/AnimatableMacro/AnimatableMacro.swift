//
//  AnimatableMacro.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//


///Animatable macro
@attached(member, names: named(animatableData), named(_AnimatableDataVector))
public macro Animatable() = #externalMacro(module: "AnimatableMacroMacros", type: "AnimatableMacro")

///AnimatableIgnored placeholder macro
@attached(peer)
public macro AnimatableIgnored() = #externalMacro(module: "AnimatableMacroMacros", type: "AnimatableIgnored")
