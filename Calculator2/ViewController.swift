
//
//  ViewController.swift
//  Calculator2
//
//  Created by Andrew Loutfi on 2/15/16.
//  Copyright © 2016 Andrew Loutfi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var history: UILabel!

    @IBOutlet weak var display: UILabel!
    var decimalUsed: Bool = false //this is poor practice. allow for inference
    
    var historyStack = Array<String>()
    
    var brain = CalculatorBrain()
    
    var userInputing = false
    let x = M_PI
    
    @IBAction func decimal(sender: UIButton) {
        if decimalUsed == false{
            userInputing = true
            display.text = display.text! + "."
            decimalUsed = true
        }
    }
    
    @IBAction func pi(sender: UIButton) {
        userInputing = true
      //  if display.text != "0" {
            display.text = "\(x)"
       // }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle! //! unwraps or crashes if optional is nil
        if userInputing {
            display.text = display.text! + digit
        }else{
            display.text = digit
            userInputing = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        historyStack.insert(String(operation), atIndex:0)
        history.text = "\(historyStack)"
        if userInputing {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    
    }
    
    @nonobjc
    
    
    
    @IBAction func clear() {
        userInputing = false
        display.text = "0"
        brain.clearOperationStack()
    }
    
    @IBAction func enter() {
        decimalUsed = false
        userInputing = false
        historyStack.insert(String(displayValue), atIndex:00)
        history.text = "\(historyStack)"
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    
    var displayValue: Double{
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue //calling nsnumberformatter class
        }
        set {
            display.text = "\(newValue)"
            userInputing = false
        }
    }

}

