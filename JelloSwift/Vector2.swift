//
//  Vector2.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 07/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import CoreGraphics

/// Represents a 2D vector
public struct Vector2: Equatable, CustomStringConvertible
{
    /// A zeroed-value Vector2
    public static let Zero = Vector2(0, 0)
    /// A one-valued Vector2
    public static let One = Vector2(1, 1)
    
    public var X: CGFloat
    public var Y: CGFloat
    public var description: String { return toString() }
    
    public var cgPoint: CGPoint { return CGPoint(x: X, y: Y) }
    
    public init()
    {
        X = 0
        Y = 0
    }
    
    public init(_ x: Int, _ y: Int)
    {
        X = CGFloat(x)
        Y = CGFloat(y)
    }
    
    public init(_ x:CGFloat, _ y:CGFloat)
    {
        X = x
        Y = y
    }
    
    public init(_ x:Double, _ y:Double)
    {
        X = CGFloat(x)
        Y = CGFloat(y)
    }
    
    public init(value: CGFloat)
    {
        X = value
        Y = value
    }
    
    public init(_ point: CGPoint)
    {
        X = point.x
        Y = point.y
    }
    
    /// Returns the angle in radians of this Vector2
    public func angle() -> CGFloat
    {
        return atan2(Y, X)
    }
    
    /// Returns the squared length of this Vector2
    public func length() -> CGFloat
    {
        return X * X + Y * Y
    }
    
    /// Returns the magnitude (or square root of the squared length) of this Vector2
    public func magnitude() -> CGFloat
    {
        return sqrt(length())
    }
    
    /// Returns the distance between this Vector2 and another Vector2
    public func distanceTo(vec: Vector2) -> CGFloat
    {
        return (self - vec).magnitude()
    }
    
    /// Returns the distance squared between this Vector2 and another Vector2
    public func distanceToSquared(vec: Vector2) -> CGFloat
    {
        return (self - vec).length()
    }
    
    /// Makes this Vector2 perpendicular to its current position.
    /// This alters the vector instance
    public mutating func perpendicularThis() -> Vector2
    {
        self = perpendicular()
        
        return self
    }
    
    /// Returns a Vector2 perpendicular to this Vector2
    public func perpendicular() -> Vector2
    {
        return Vector2(-Y, X)
    }
    
    // Normalizes this Vector2 instance.
    // This alters the current vector instance
    public mutating func normalizeThis() -> Vector2
    {
        self = normalized()
        
        return self
    }
    
    /// Returns a normalized version of this Vector2
    public func normalized() -> Vector2
    {
        let mag = magnitude()
        
        if(mag > CGFloat.min)
        {
            return self / mag
        }
        
        return self
    }
    
    /// Returns a string representation of this Vector2 value
    public func toString() -> String
    {
        return "{ \(self.X) : \(self.Y) }"
    }
}

/// Returns a Vector2 that represents the minimum coordinates between two Vector2 objects
public func min(a: Vector2, _ b: Vector2) -> Vector2
{
    return Vector2(min(a.X, b.X), min(a.Y, b.Y))
}

/// Returns a Vector2 that represents the maximum coordinates between two Vector2 objects
public func max(a: Vector2, _ b: Vector2) -> Vector2
{
    return Vector2(max(a.X, b.X), max(a.Y, b.Y))
}

/// Rotates a given vector by an angle in radians
public func rotateVector(vec: Vector2, angleInRadians: CGFloat) -> Vector2
{
    if(angleInRadians % (PI * 2) == 0)
    {
        return vec
    }
    
    let c = cos(angleInRadians)
    let s = sin(angleInRadians)
    
    return Vector2((c * vec.X) - (s * vec.Y), (c * vec.Y) + (s * vec.X))
}

public func rotateVector(vec: Vector2, angleInRadians: Double) -> Vector2
{
    if(angleInRadians % (M_PI * 2) == 0)
    {
        return vec
    }
    
    let c = CGFloat(cos(angleInRadians))
    let s = CGFloat(sin(angleInRadians))
    
    return Vector2((c * vec.X) - (s * vec.Y), (c * vec.Y) + (s * vec.X))
}

/// Returns whether rotating from A to B is counter-clockwise
public func vectorsAreCCW(A: Vector2, B: Vector2) -> Bool
{
    return (B =* A.perpendicular()) >= 0.0
}

/// Averages a list of vectors into one normalized Vector2 point
public func averageVectors(vectors: [Vector2]) -> Vector2
{
    return (vectors.reduce(Vector2.Zero, combine: +) / vectors.count)
}

////////
//// Define the operations to be performed on the Vector2
////////
infix operator =* { associativity left precedence 150 }
infix operator =/ { associativity left precedence 151 }

////
// Comparision operators
////
public func ==(lhs: Vector2, rhs: Vector2) -> Bool
{
    return funcOnVectors(lhs, rhs, ==)
}

// Unary operators
public prefix func -(lhs: Vector2) -> Vector2
{
    return Vector2(-lhs.X, -lhs.Y)
}

public prefix func ++(inout x: Vector2) -> Vector2
{
    return Vector2(++x.X, ++x.Y)
}

public postfix func ++(inout x: Vector2) -> Vector2
{
    return Vector2(x.X++, x.Y++)
}

public prefix func --(inout x: Vector2) -> Vector2
{
    return Vector2(--x.X, --x.Y)
}

public postfix func --(inout x: Vector2) -> Vector2
{
    return Vector2(x.X--, x.Y--)
}

// DOT operator
/// Calculates the dot product between two provided coordinates
public func =*(lhs: Vector2, rhs: Vector2) -> CGFloat
{
    return lhs.X * rhs.X + lhs.Y * rhs.Y
}

// CROSS operator
public func =/(lhs: Vector2, rhs: Vector2) -> CGFloat
{
    return lhs.X * rhs.X - lhs.Y * rhs.Y
}

////
// Basic arithmetic operators
////
public func +(lhs: Vector2, rhs: Vector2) -> Vector2
{
    return funcOnVectors(lhs, rhs, +)
}
public func -(lhs: Vector2, rhs: Vector2) -> Vector2
{
    return funcOnVectors(lhs, rhs, -)
}
public func *(lhs: Vector2, rhs: Vector2) -> Vector2
{
    return funcOnVectors(lhs, rhs, *)
}
public func /(lhs: Vector2, rhs: Vector2) -> Vector2
{
    return funcOnVectors(lhs, rhs, /)
}
public func %(lhs: Vector2, rhs: Vector2) -> Vector2
{
    return funcOnVectors(lhs, rhs, %)
}

// CGFloat interaction
public func +(lhs: Vector2, rhs: CGFloat) -> Vector2
{
    return funcOnVectors(lhs, rhs, +)
}
public func -(lhs: Vector2, rhs: CGFloat) -> Vector2
{
    return funcOnVectors(lhs, rhs, -)
}
public func *(lhs: Vector2, rhs: CGFloat) -> Vector2
{
    return funcOnVectors(lhs, rhs, *)
}
public func /(lhs: Vector2, rhs: CGFloat) -> Vector2
{
    return funcOnVectors(lhs, rhs, /)
}
public func %(lhs: Vector2, rhs: CGFloat) -> Vector2
{
    return funcOnVectors(lhs, rhs, %)
}

private func funcOnVectors(lhs: Vector2, _ rhs: Vector2, _ f: (CGFloat, CGFloat) -> CGFloat) -> Vector2
{
    return Vector2(f(lhs.X, rhs.X), f(lhs.Y, rhs.Y))
}

private func funcOnVectors(lhs: Vector2, _ rhs: CGFloat, _ f: (CGFloat, CGFloat) -> CGFloat) -> Vector2
{
    return Vector2(f(lhs.X, rhs), f(lhs.Y, rhs))
}

private func funcOnVectors(lhs: Vector2, _ rhs: Vector2, _ f: (CGFloat, CGFloat) -> Bool) -> Bool
{
    return f(lhs.X, rhs.X) && f(lhs.Y, rhs.Y)
}

// Int interaction
public func +(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs + CGFloat(rhs)
}
public func -(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs - CGFloat(rhs)
}
public func *(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs * CGFloat(rhs)
}
public func /(lhs: Vector2, rhs: Int) -> Vector2
{
    return lhs / CGFloat(rhs)
}

////
// Compound assignment operators
////
public func +=(inout lhs: Vector2, rhs: Vector2)
{
    lhs = lhs + rhs
}
public func -=(inout lhs: Vector2, rhs: Vector2)
{
    lhs = lhs - rhs
}
public func *=(inout lhs: Vector2, rhs: Vector2)
{
    lhs = lhs * rhs
}
public func /=(inout lhs: Vector2, rhs: Vector2)
{
    lhs = lhs / rhs
}

// CGFloat interaction
public func +=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs + rhs
}
public func -=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs - rhs
}
public func *=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs * rhs
}
public func /=(inout lhs: Vector2, rhs: CGFloat)
{
    lhs = lhs / rhs
}

// Int interaction
public func +=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs + rhs
}
public func -=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs - rhs
}
public func *=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs * rhs
}
public func /=(inout lhs: Vector2, rhs: Int)
{
    lhs = lhs / rhs
}
