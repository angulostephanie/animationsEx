//
//  CanvasViewController.swift
//  animationExample
//
//  Created by Stephanie Angulo on 6/30/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffSet: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var scale: CGFloat!
    var rotation: CGFloat!
    
    
    @IBOutlet weak var trayView: UIView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffSet = 200
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffSet)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCustomPan(sender: UIPanGestureRecognizer) {
//        var point  = sender.locationInView(view)
//        var velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            print("Gesture began")
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("Gesture changed")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("Gesture ended")
        }
    }
    func didPinchNewFace(sender: UIPinchGestureRecognizer) {
        scale = sender.scale
        self.newlyCreatedFace.transform = CGAffineTransformScale(self.view.transform, scale, scale)
        print("pinched")
        scale = scale + sender.scale
        
    }
    func didRotateFace(sender: UIRotationGestureRecognizer) {
        rotation = sender.rotation
        self.newlyCreatedFace.transform = CGAffineTransformRotate(self.view.transform, rotation)
        print("its rotating")
        rotation = rotation + sender.rotation
        //rotation = 0
    }
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocityInView(view)

        let translation = sender.translationInView(trayView)
        if sender.state == UIGestureRecognizerState.Began {
            print("gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            print("gesture is changing")
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("ended")
            if velocity.y > 0 {
                print("Moving down")
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { 
                    self.trayView.center = self.trayDown
                    }, completion: { (Bool) -> Void in
                })
            } else {
                print("moving up")
            }
        }
    }
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        let imageView = sender.view as? UIImageView
        let translation = sender.translationInView(trayView)
        if sender.state == UIGestureRecognizerState.Began {
            print("gesture began")
            newlyCreatedFace = UIImageView(image: imageView!.image)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onCustomPan))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchNewFace))
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotateFace))
            
            view.addSubview(newlyCreatedFace)
            
            
            newlyCreatedFace.center = imageView!.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
           
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = CGAffineTransformMakeScale(2.2,2.2)
            
            newlyCreatedFace.userInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)

            
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("ended")
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.7,1.7)
                }, completion: { (Bool) -> Void in
            })
        }
    
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
