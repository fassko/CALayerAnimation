//
//  ViewController.swift
//  CALayerAnimation
//
//  Created by Kristaps Grinbergs on 25/07/2017.
//  Copyright © 2017 qminder. All rights reserved.
//

import UIKit

import QuartzCore

class ViewController: UIViewController {
  
  @IBOutlet weak var viewForLayer: UIView!
  
  var shapeLayer: CAShapeLayer!
  
  var bezierPath: UIBezierPath!
  
  var point1 = CGPoint(x: 100, y: 55)
  var point2 = CGPoint(x: 150, y: 130)
  var point3 = CGPoint(x: 50, y: 130)
  
  var center = CGPoint(x: 100, y: 55)
  
  var beziers: [UIBezierPath] = []
   

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = CGMutablePath()
    
    
    shapeLayer = CAShapeLayer()
    
    
    
    
    for i in 0...3 {
      beziers.append(createBezierPath(point1: randomPointOnCircle(radius: 20.0, center: center), point2: point2, point3: point3))
    }
    
    
    
    
//    bezierPath = createBezierPath(point1: randomPointOnCircle(radius: 10.0, center: center), point2: point2, point3: point3)
//
//    point1.x += 30
//
//    bezier2Path = createBezierPath(point1: point1, point2: point2, point3: point3)
//
//    point1.y += 30
//
//    bezier3Path = createBezierPath(point1: point1, point2: point2, point3: point3)
    
    shapeLayer?.path = beziers.first?.cgPath
    
    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.lineWidth = 1.0
    shapeLayer.fillColor = UIColor.clear.cgColor
    
    
    viewForLayer.layer.addSublayer(shapeLayer)
    
  }
  
  func createBezierPath(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    bezierPath.move(to: point1)
    bezierPath.addLine(to: point2)
    bezierPath.addLine(to: point3)
    bezierPath.close()
//    UIColor.black.setStroke()
//    bezierPath.lineWidth = 1.5
//    bezierPath.lineCapStyle = .round
//    bezierPath.lineJoinStyle = .round
//    bezierPath.stroke()
    
    return bezierPath
  }
  
  @IBAction func animate(_ sender: Any) {
    
    let group = CAAnimationGroup()
    var animations: [CAAnimation] = []
    
    
//    for i in 0...2 {
//      let animation = CABasicAnimation(keyPath: "path\(i)")
//      animation.fromValue = i == 0 ? shapeLayer.path : beziers[i-1]
//      animation.toValue = beziers[i]
//      animation.duration = 1.0
//      animation.repeatCount = .infinity
//      animation.fillMode = kCAFillModeForwards
//      animation.isRemovedOnCompletion = false
//      animation.autoreverses = true
//      animations.append(animation)
//    }
    
//    let animation = CABasicAnimation(keyPath: "path1")
//    animation.fromValue = shapeLayer.path
//    animation.toValue = createBezierPath(point1: randomPointOnCircle(radius: 10.0, center: center), point2: point2, point3: point3).cgPath
//    animation.duration = 1.0
//    animation.repeatCount = .infinity
//    animation.fillMode = kCAFillModeForwards
//    animation.isRemovedOnCompletion = false
//    animation.autoreverses = true
//    animations.append(animation)
//    
//    let animation2 = CABasicAnimation(keyPath: "path2")
//    animation2.fromValue = shapeLayer.path
//    animation2.toValue = createBezierPath(point1: randomPointOnCircle(radius: 10.0, center: center), point2: point2, point3: point3).cgPath
//    animation2.duration = 1.0
//    animation2.repeatCount = .infinity
//    animation2.fillMode = kCAFillModeForwards
//    animation2.isRemovedOnCompletion = false
//    animation2.autoreverses = true
//    animations.append(animation2)
    
    let animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = beziers[0].cgPath
    animation.toValue = beziers[1].cgPath
    animation.duration = 1.0
    animation.beginTime = 0.0
//    animation.repeatCount = .infinity
//    animation.fillMode = kCAFillModeForwards
//    animation.isRemovedOnCompletion = false
//    animation.autoreverses = true
    
    animations.append(animation)
    
    let animation2 = CABasicAnimation(keyPath: "path")
    animation2.fromValue = beziers[1].cgPath
    animation2.toValue = beziers[2].cgPath
    animation2.duration = 1.0
    animation2.beginTime = animation.beginTime + animation.duration
//    animation2.repeatCount = .infinity
//    animation2.fillMode = kCAFillModeForwards
//    animation2.isRemovedOnCompletion = false
//    animation2.autoreverses = true
    animations.append(animation2)
    
    let animation3 = CABasicAnimation(keyPath: "path")
    animation3.fromValue = beziers[2].cgPath
    animation3.toValue = beziers[3].cgPath
    animation3.duration = 1.0
    animation3.beginTime = animation2.beginTime + animation.duration
//    animation3.repeatCount = .infinity
//    animation3.fillMode = kCAFillModeForwards
//    animation3.isRemovedOnCompletion = false
//    animation3.autoreverses = true
    animations.append(animation3)
    
    group.animations = animations //[animation, animation2]
    group.repeatCount = .infinity
    group.duration = animation3.beginTime + animation3.duration
    group.isRemovedOnCompletion = false
    group.fillMode = kCAFillModeForwards
    group.autoreverses = true
    
    shapeLayer.add(group, forKey: "anim")
  }
  
  func randomPointOnCircle(radius:Float, center:CGPoint) -> CGPoint {
    // Random angle in [0, 2*pi]
    let theta = Float(arc4random_uniform(UInt32.max))/Float(UInt32.max-1) * Float.pi * 2.0
    // Convert polar to cartesian
    let x = radius * cos(theta)
    let y = radius * sin(theta)
    return CGPoint(x: CGFloat(x)+center.x, y: CGFloat(y)+center.y)
  }
  
}

