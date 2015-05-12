//
//  InstructionViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 5/5/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    // 'textToBeSet' can be set from another View Controller that instantiates this one.
    // In viewDidLoad() we will take care of setting the actual text view body to this String
    var textToBeSet: String = ""
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.text = textToBeSet
//        centerText()
    }
    
    func resizeTextView() {
        let fixedWidth = text.frame.size.width
        let newSize = text.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT)))
        var newFrame = text.frame
        newFrame.size = CGSizeMake(CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), newSize.height);
        text.frame = newFrame
    }
    
//    func centerText() {
//        var topCorrect = text.bounds.size.height - text.contentSize.height
//        topCorrect = (topCorrect < 0.0 ? 0.0 : topCorrect)
//        text.contentInset = UIEdgeInsetsMake(topCorrect, 0, 0, 0)
//    }
    
}
