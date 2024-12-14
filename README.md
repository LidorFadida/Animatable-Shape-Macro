# Animatable-Shape-Macro

**Animatable-Shape-Macro** is a Swift package that leverages the Swift Macros system to simplify the creation and handling of animatable shapes within SwiftUI. With these custom macros, you can more easily declare and integrate shapes that animate smoothly, reducing boilerplate code and improving clarity in your codebase.

## Overview

This package uses Swift Macros to automatically generate and manage properties, builders, and vector declarations for shapes that need to animate over time. By annotating your shape types or properties with the provided macros, the infrastructure handles tedious repetitive logic, making it easier to:

- Define shapes that conform to `Animatable` and `Shape` protocols.
- Automatically generate properties and initializers to support animations.
- Integrate seamlessly with SwiftUI’s animation system, making your shapes smoothly respond to state changes.

## Installation

### Swift Package Manager

Add **Animatable-Shape-Macro** to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/lidorfadida/Animatable-Shape-Macro.git", from: "1.0.0")
```

## Usage 

**1. Import the Macro Module:**

```swift 
import AnimatableMacro
```

**2. Apply Macros to Your Shape:**
   
```swift
  @AnimatableMacro
  struct MyCustomShape: Shape {
      var animatedProperty: CGFloat
    
      func path(in rect: CGRect) -> Path {
        // Define your shape's path based on animatableData
      }
  }
```

After applying the macro, the shape will gain additional synthesized code that makes it easier to animate.

**3. Exclude Properties if Needed:**

If there are certain properties you don’t want to be included in the generated animatable data, you can mark them with ```@AnimatableIgnored```:
   
```swift
  @AnimatableMacro
  struct MyAdvancedShape: Shape {
      var animatedProperty: CGFloat
    
      @AnimatableIgnored
      var nonAnimatableInfo: String

      func path(in rect: CGRect) -> Path {
        // animatedProperty will animate, nonAnimatableInfo won't
      }
  }
```

## Testing

The package includes tests (using swift-macro-testing and swift-snapshot-testing) to ensure that macros generate the expected code. To run tests:
```bash
swift test
```

## Contributing

Contributions are welcome. If you find a bug, have a feature request, or want to contribute improvements, feel free to open an issue or submit a pull request.


## Contact

If you have any questions or feedback, feel free to contact me on [LinkedIn](https://www.linkedin.com/in/lidor-fadida/).
