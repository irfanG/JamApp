//
//  BaseVC.swift
//  DzematApp
//
//  Created by Irfan Godinjak on 03/07/16.
//  Copyright © 2016 eu.devlogic. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    var backgroundGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackgroundColor(){
        backgroundGradientLayer.frame = view.bounds
        // NOTE: This taught me how to do a gradient in Swift: http://stackoverflow.com/questions/23074539/programmatically-create-a-uiview-with-color-gradient
        // NOTE: the startPoint & endPoint are defined in the *unit* coordinate space (i.e. [(0, 0), (1, 1)]); it may be worth writing a journal article about this; also I should read up on CoreGraphics
        // NOTE: the default gradient direction is top-down; this SO answer helped guide me to make it horizontal/diagonal, etc.: http://stackoverflow.com/questions/24068813/creating-a-horizontal-gradient-on-uitableviewcell
        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        let maxBoundsSideLength = max(view.bounds.maxX, view.bounds.maxY)
        backgroundGradientLayer.endPoint = CGPoint(x: view.bounds.maxX / maxBoundsSideLength, y: view.bounds.maxY / maxBoundsSideLength)
        backgroundGradientLayer.colors = [UIColor.pastelGreen.CGColor, UIColor.apple.CGColor]
        view.layer.insertSublayer(backgroundGradientLayer, atIndex: 0)
    }
    
    func hideNavigationBar(shouldHideNavBar: Bool){
        navigationController?.navigationBarHidden = shouldHideNavBar
    }
    
}

protocol BaseVCProtocol {
    func setupView()
    func registerNIB()

}
