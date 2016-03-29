//
//  GraphViewController.swift
//  Calculator2
//
//  Created by Andrew Loutfi on 3/14/16.
//  Copyright © 2016 Andrew Loutfi. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource, UIPopoverPresentationControllerDelegate {
    
    private struct Constants {
        static let ScaleAndOrigin = "scaleAndOrigin"
    }
    
    @IBOutlet weak var graphView: GraphView!{
        didSet {
            graphView.dataSource = self
            if let scaleAndOrigin = userDefaults.objectForKey(Constants.ScaleAndOrigin) as? [String: String] {
                graphView.scaleAndOrigin = scaleAndOrigin
            }
        }
        
    }
    
    @IBAction func moveOrigin(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            graphView.graphOrigin = gesture.locationInView(view)
            saveInput()
        default: break
        }
    }

    
    @IBAction func moveGraph(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(graphView)
            
            if graphView.graphOrigin == nil {
                graphView.graphOrigin = CGPoint(
                    x: graphView.center.x + translation.x,
                    y: graphView.center.y + translation.y)
            } else {
                graphView.graphOrigin = CGPoint(
                    x: graphView.graphOrigin!.x + translation.x,
                    y: graphView.graphOrigin!.y + translation.y)
            }
            
            saveInput()
            
            gesture.setTranslation(CGPointZero, inView: graphView)
        default: break
        }
    }
    
    @IBAction func zoomGraph(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            graphView.scale *= gesture.scale
            saveInput()
            gesture.scale = 1
        }
    }
    

    
 

    
    
    var program: AnyObject?
    var graphLabel: String? {
        didSet {
            title = graphLabel
        }
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()

    
    private func saveInput() {
        userDefaults.setObject(graphView.scaleAndOrigin, forKey: Constants.ScaleAndOrigin)
        userDefaults.synchronize()
    }
    
    func graphPlot(sender: GraphView) -> [(x: Double, y: Double)]? {
        
        let plots = [(x: Double, y: Double)]()

        return plots
    }

    
 
    
}

