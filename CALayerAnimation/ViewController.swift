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
  
  @IBOutlet weak var pauseResumeButton: UIButton!
  
  
  private var shapeLayer: CAShapeLayer!
  
  private var bezierPath: UIBezierPath!
  
  private var point1 = CGPoint(x: 100, y: 55)
  private var point2 = CGPoint(x: 150, y: 130)
  private var point3 = CGPoint(x: 50, y: 130)
  
  private var center = CGPoint(x: 100, y: 55)
  
  private var beziers: [UIBezierPath] = []
  
  private var paused: Bool = false {
    didSet {
      pauseResumeButton.setTitle(paused ? "Resume" : "Pause", for: .normal)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    shapeLayer = CAShapeLayer()
    
    let spiral = drawSpiral(arc: 10.0, separation: 3.0, numPoints: 100)
    
    var points: [CGPoint] = []
    
    for point in spiral {
      points.append(CGPoint(x: CGFloat(point.0) + center.x, y: CGFloat(point.1) + center.y))
    }
    
    for point in points {
      beziers.append(createBezierPath(point1: point, point2: point2, point3: point3))
    }
    
    shapeLayer?.path = beziers.first?.cgPath
    
    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.lineWidth = 1.0
    shapeLayer.fillColor = UIColor.clear.cgColor
    
    viewForLayer.layer.addSublayer(shapeLayer)
    
    pauseResumeButton.isEnabled = false
  }
  
  func createBezierPath(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    bezierPath.move(to: point1)
    bezierPath.addLine(to: point2)
    bezierPath.addLine(to: point3)
    bezierPath.close()
    
    return bezierPath
  }
  
  @IBAction func animate(_ sender: Any) {
    
    let group = CAAnimationGroup()
    var animations: [CAAnimation] = []
    
    for i in 0...beziers.count-2 {
      let animation = CABasicAnimation(keyPath: "path")
      animation.fromValue = beziers[i].cgPath
      animation.toValue = beziers[i+1].cgPath
      animation.duration = 1.0
      animation.beginTime = CFTimeInterval(1 * i)
      animations.append(animation)
    }
    
    group.animations = animations
    group.repeatCount = .infinity
    group.duration = CFTimeInterval(animations.count)
    group.isRemovedOnCompletion = false
    group.fillMode = kCAFillModeForwards
    group.autoreverses = true
    
    shapeLayer.add(group, forKey: "anim")
    
    paused = false
    pauseResumeButton.isEnabled = true
  }
  
  @IBAction func pauseResume(_ sender: Any) {
    if paused {
      let pausedTime = shapeLayer.timeOffset
      shapeLayer.speed = 1.0
      shapeLayer.timeOffset = 0.0
      shapeLayer.beginTime = 0.0
      let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
      shapeLayer.beginTime = timeSincePause
      
      paused = false
    } else {
      let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
      shapeLayer.speed = 0.0
      shapeLayer.timeOffset = pausedTime
      
      paused = true
    }
  }
  
  
  func randomPointOnCircle(radius:Float, center:CGPoint) -> CGPoint {
    // Random angle in [0, 2*pi]
    let theta = Float(arc4random_uniform(UInt32.max))/Float(UInt32.max-1) * Float.pi * 2.0
    // Convert polar to cartesian
    let x = radius * cos(theta)
    let y = radius * sin(theta)
    return CGPoint(x: CGFloat(x)+center.x, y: CGFloat(y)+center.y)
  }
  
  func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
  }
  
  
  func drawSpiral(arc: Double, separation: Double, numPoints: Int) -> [(Double,Double)] {
    
    /**
    generate points on an Archimedes' spiral
    with `arc` giving the length of arc between two points
    and `separation` giving the distance between consecutive
    turnings
      - approximate arc length with circle arc at given distance
        - use a spiral equation r = b * phi
    **/
    
    var numPoints = numPoints
    
    // polar to cartesian
    func p2c(r:Double, phi: Double) -> (Double,Double) {
      return (r * cos(phi), r * sin(phi))
    }
    
    // yield a point at origin
    var result = [(Double(0), Double(0))]
    
    // initialize the next point in the required distance
    var r = arc
    let b = separation / (2 * .pi)
    
    // find the first phi to satisfy distance of `arc` to the second point
    var phi = r / b
    
    while numPoints > 0 {
      result.append(p2c(r: r, phi: phi))
      
//      advance the variables
//      calculate phi that will give desired arc length at current radius
//      (approximating with circle)
      
      phi += arc / r
      r = b * phi
      numPoints -= 1
    }
    
    return result
  }
  
}

