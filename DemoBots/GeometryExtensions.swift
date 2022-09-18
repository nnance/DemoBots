/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A series of extensions to provide convenience interoperation between `CGPoint` representations of geometric points (common in SpriteKit) and `SIMD2<Float>` representations of points (common in GameplayKit).
*/

import CoreGraphics
import simd

// Extend `CGPoint` to add an initializer from a `float2` representation of a point.
extension CGPoint {
    // MARK: Initializers
    
    /// Initialize with a `float2` type.
    init(_ point: SIMD2<Float>) {
        self.init()
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }
}

// Extend `float2` to add an initializer from a `CGPoint`.
extension SIMD2 where Scalar == Float {
    // MARK: Initialization
    
    /// Initialize with a `CGPoint` type.
    init(_ point: CGPoint) {
        self.init(x: Float(point.x), y: Float(point.y))
    }
}

/// An equality operator function to determine if two `SIMD2<Float>`s are the same.
public func ==(lhs: SIMD2<Float>, rhs: SIMD2<Float>) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

// Extend `SIMD2<Float>` to provide a convenience method for working with pathfinding graphs.
extension SIMD2 where Scalar == Float {
    /// Calculates the nearest point to this point on a line from `pointA` to `pointB`.
    func nearestPointOnLineSegment(lineSegment: (startPoint: SIMD2<Float>, endPoint: SIMD2<Float>)) -> SIMD2<Float> {
        // A vector from this point to the line start.
        let vectorFromStartToLine = self - lineSegment.startPoint
        
        // The vector that represents the line segment.
        let lineSegmentVector = lineSegment.endPoint - lineSegment.startPoint
        
        // The length of the line squared.
        let lineLengthSquared = distance_squared(lineSegment.startPoint, lineSegment.endPoint)
        
        // The amount of the vector from this point that lies along the line.
        let projectionAlongSegment = dot(vectorFromStartToLine, lineSegmentVector)
        
        // Component of the vector from the point that lies along the line.
        let componentInSegment = projectionAlongSegment / lineLengthSquared
        
        // Clamps the component between [0 - 1].
        let fractionOfComponent = Swift.max(0, Swift.min(1, componentInSegment))
        
        return lineSegment.startPoint + lineSegmentVector * fractionOfComponent
    }
}
