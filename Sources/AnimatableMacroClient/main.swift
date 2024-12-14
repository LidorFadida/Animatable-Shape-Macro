//
//  main.swift
//  AnimatableMacro
//
//  Created by Lidor Fadida on 14/12/2024.
//


import AnimatableMacro
import SwiftUI



@Animatable
struct MyShapeWithoutProperties: Shape {
    func path(in rect: CGRect) -> Path { return Path { path in } }
}

@Animatable
struct MyShapeWithSingleProperties: Shape {
    var myValue: CGFloat
    func path(in rect: CGRect) -> Path { return Path { path in } }
}

@Animatable
struct MyShapeWithMultiplePropertiesAndIgnored: Shape {
    var radius: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    ///inline
    @AnimatableIgnored var dOffset: Int
    ///break line
    @AnimatableIgnored
    var zOffset: Int
    
    func path(in rect: CGRect) -> Path { return Path() }
}

@Animatable
struct MyShapeWithMultiplePropertiesAndIgnoredCGFloat: Shape {
    var radius: CGFloat
    ///inline
    @AnimatableIgnored var xOffset: CGFloat
    ///break line
    @AnimatableIgnored
    var yOffset: CGFloat
    
    func path(in rect: CGRect) -> Path { return Path() }
}
