//
//  PolyDrawer.swift
//  JelloSwift
//
//  Created by Luiz Fernando Silva on 09/08/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

import UIKit

private struct CoreGraphicsPoly
{
    let points: [CGPoint]
    let fillColor: UIColor
    let lineColor: UIColor
    let lineWidth: CGFloat
    
    let fillColorUInt: UInt
    let lineColorUInt: UInt
    
    var bounds: CGRect
    {
        return AABB(points: points.map(Vector2.init)).cgRect
    }
    
    init(points: [CGPoint], lineColor: UInt, fillColor: UInt, lineWidth: CGFloat)
    {
        var points = points
        // Wrap the values around so the shape is closed
        if let first = points.first
        {
            points.append(first)
        }
        
        self.points = points
        self.lineColor = colorFromUInt(lineColor)
        self.fillColor = colorFromUInt(fillColor)
        lineColorUInt = lineColor
        fillColorUInt = fillColor
        self.lineWidth = lineWidth
    }
}

/// A polygon drawing helper that caches SKSpriteNodes and uses CGPaths to draw custom polygons.
/// Not the most elegant or fastest way, but SpriteKit lacks any viable options for constant drawing
/// of arbitrary polygons easily.
class PolyDrawer
{
    /// An array of polygons to draw on the next flush call
    fileprivate var polys: [CoreGraphicsPoly] = []
    
    func queuePoly<T: Sequence>(_ vertices: T, fillColor: UInt, strokeColor: UInt, lineWidth: CGFloat = 3) where T.Iterator.Element == CGPoint
    {
        let poly = CoreGraphicsPoly(points: [CGPoint](vertices), lineColor: strokeColor, fillColor: fillColor, lineWidth: lineWidth)
        
        self.polys += poly
    }
    
    /// Renders the contents of this PolyDrawer on a given CGContextRef
    func renderOnContext(_ context: CGContext)
    {
        for poly in polys
        {
            let hasFill = ((poly.fillColorUInt >> 24) & 0xFF) != 0
            let hasLine = ((poly.lineColorUInt >> 24) & 0xFF) != 0
            
            // Shape is invisible
            if(!hasFill && !hasLine)
            {
                continue
            }
            
            context.saveGState()
            
            let path = CGMutablePath()
            
            path.addLines(between: poly.points)
          
            context.setStrokeColor(poly.lineColor.cgColor)
            context.setFillColor(poly.fillColor.cgColor)
            context.setLineWidth(poly.lineWidth)
            context.setLineJoin(CGLineJoin.round)
            context.setLineCap(CGLineCap.round)
            
            context.addPath(path)
            
            if(hasLine && hasFill && poly.points.count > 3)
            {
                context.drawPath(using: CGPathDrawingMode.fillStroke)
            }
            else
            {
                if(hasFill && poly.points.count > 3)
                {
                    context.fillPath()
                }
                if(hasLine)
                {
                    context.strokePath()
                }
            }
            
            context.restoreGState()
        }
    }
    
    /// Resets this PolyDrawer
    func reset()
    {
        polys.removeAll(keepingCapacity: false)
    }
}

func colorFromUInt(_ color: UInt) -> UIColor
{
    let a = CGFloat((color >> 24) & 0xFF) / 255.0
    let r = CGFloat((color >> 16) & 0xFF) / 255.0
    let g = CGFloat((color >> 8) & 0xFF) / 255.0
    let b = CGFloat(color & 0xFF) / 255.0
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
}
