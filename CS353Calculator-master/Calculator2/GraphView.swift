//
//  GraphView.swift
//  Calculator2
//
//  Created by Andrew Loutfi on 3/14/16.
//  Copyright © 2016 Andrew Loutfi. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func graphPlot(sender: GraphView) -> [(x: Double, y: Double)]?
}

@IBDesignable
class GraphView: UIView {
    weak var dataSource: GraphViewDataSource?
    
    @IBInspectable var axesColor: UIColor = UIColor.blackColor()
        { didSet { setNeedsDisplay() } }
    @IBInspectable var plotColor: UIColor = UIColor.blackColor()
        { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 1.0
        { didSet { setNeedsDisplay() } }
    @IBInspectable var graphOrigin: CGPoint?
        { didSet { setNeedsDisplay() } }
    
    let pointsPerUnit: CGFloat = 50.0
    
    var graphCenter: CGPoint {
        if graphOrigin != nil {
            return convertPoint(graphOrigin!, fromView: superview)
        }
        return convertPoint(center, fromView: superview)
    }
    
    typealias PropertyList = [String: String]
    var scaleAndOrigin: PropertyList {
        get {
            let origin = (graphOrigin != nil) ? graphOrigin! : center
            return [
                "scale": "\(scale)",
                "graphOriginX": "\(origin.x)",
                "graphOriginY": "\(origin.y)"
            ]
        }
        set {
            if let scale = newValue["scale"], graphOriginX = newValue["graphOriginX"], graphOriginY = newValue["graphOriginY"] {
                if let scale = NSNumberFormatter().numberFromString(scale) {
                    self.scale = CGFloat(scale)
                }
                if let graphOriginX = NSNumberFormatter().numberFromString(graphOriginX), graphOriginY = NSNumberFormatter().numberFromString(graphOriginY) {
                    self.graphOrigin = CGPoint(x: CGFloat(graphOriginX), y: CGFloat(graphOriginY))
                }
            }
        }
    }
    
    var minX: CGFloat {
        let minXBound = -(bounds.width - (bounds.width - graphCenter.x))
        return minXBound / (pointsPerUnit * scale)
    }
    var maxX: CGFloat {
        let maxXBound = bounds.width - graphCenter.x
        return maxXBound / (pointsPerUnit * scale)
    }
    var minY: CGFloat {
        let minYBound = -(bounds.height - graphCenter.y)
        return minYBound / (pointsPerUnit * scale)
    }
    var maxY: CGFloat {
        let maxYBound = bounds.height - (bounds.height - graphCenter.y)
        return maxYBound / (pointsPerUnit * scale)
    }

    var availablePixelsInXAxis: Double {
        return Double(bounds.width * contentScaleFactor)
    }
    var availablePixelsInYAxis: Double {
        return Double(bounds.height * contentScaleFactor)
    }
    
    private func translatePlot(plot: (x: Double, y: Double)) -> CGPoint {
        let X = CGFloat(plot.x) * pointsPerUnit * scale + graphCenter.x
        let Y = CGFloat(-plot.y) * pointsPerUnit * scale + graphCenter.y
        return CGPoint(x: X,y: Y)
    }
    
    override func drawRect(rect: CGRect) {
        let axes = AxesDrawer(color: axesColor, contentScaleFactor: contentScaleFactor)
        axes.drawAxesInRect(bounds, origin: graphCenter, pointsPerUnit: pointsPerUnit*scale)
        
        let bezierPath = UIBezierPath()
        
        if var plots = dataSource?.graphPlot(self) where plots.first != nil {
            bezierPath.moveToPoint(translatePlot((x: plots.first!.x, y: plots.first!.y)))
            plots.removeFirst()
            for plot in plots {
                bezierPath.addLineToPoint(translatePlot((x: plot.x, y: plot.y)))
            }
        }
        
        plotColor.set()
        bezierPath.stroke()
        
    }
    
}
