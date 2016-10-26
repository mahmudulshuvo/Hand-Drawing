//
//  ViewController.swift
//  HandDrawing
//
//  Created by Mahmudul Hassan on 10/23/16.
//  Copyright © 2016 SHUVO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var drawingStackView: UIStackView!
    
    let mainDrawLayer = CAShapeLayer()
    let mainDrawPath = UIBezierPath()
    
    let coalescedDrawLayer = CAShapeLayer()
    let coalescedDrawPath = UIBezierPath()

    
    var layers: [CAShapeLayer] = []
    var paths: [UIBezierPath] = []
    
    required init?(coder aDecoder: NSCoder)
    {
        layers = [mainDrawLayer, coalescedDrawLayer]
        paths = [mainDrawPath, coalescedDrawPath]
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.addSubview(drawingStackView)
        drawingStackView.addArrangedSubview(drawingView)
        
        for layer in layers
        {
            layer.lineCap = kCALineCapRound
            layer.lineWidth = 10.0
            layer.fillColor = nil
            drawingView.layer.addSublayer(layer)
        }
        
        
        // mainDrawLayer
        
        mainDrawLayer.strokeColor = UIColor.blue.cgColor
        
        // coalescedDrawLayer
        
        coalescedDrawLayer.strokeColor = UIColor.yellow.cgColor
        
    }
    

    @IBAction func btnPressed(_ sender: AnyObject) {

        for (path, layer) in zip(paths, layers)
        {
            path.removeAllPoints()
            
            layer.path = path.cgPath
            layer.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        
        for (path, layer) in zip(paths, layers)
        {
          //  path.removeAllPoints()
            
            layer.path = path.cgPath
            layer.isHidden = false
        }
        
        let touch = touches.first
        
        if(touch?.view == drawingView){
            // Code
            
            let locationInView = touch?.location(in: drawingView)
            
            for path in paths
            {
                path.move(to: locationInView!)
            }
            
            for layer in layers
            {
                layer.isHidden = false
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)

        let touch = touches.first
        
        if(touch?.view == drawingView){
            
            
            let locationInView = touch?.location(in: drawingView)
            
            // Main Draw
            mainDrawPath.addLine(to: locationInView!)
            mainDrawPath.move(to: locationInView!)
            mainDrawLayer.path = mainDrawPath.cgPath
            
            
            //Coalesced Draw
            if let coalescedTouches = event?.coalescedTouches(for: touch!)
            {
                
                for coalescedTouch in coalescedTouches
                {
                    let locationInView = coalescedTouch.location(in: drawingView)
                    
                    coalescedDrawPath.addLine(to: locationInView)
                    coalescedDrawPath.move(to: locationInView)
                }
                
                coalescedDrawLayer.path = coalescedDrawPath.cgPath
            }
            
            var foo = Double(1)
            
            for bar in 0 ... 4_000_000
            {
                foo += sqrt(Double(bar))
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
    }
    
    
    override func viewDidLayoutSubviews()
    {
        
        drawingStackView.axis = self.view.frame.width > self.view.frame.height
            ? UILayoutConstraintAxis.horizontal
            : UILayoutConstraintAxis.vertical
        drawingStackView.distribution = UIStackViewDistribution.fillEqually
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

