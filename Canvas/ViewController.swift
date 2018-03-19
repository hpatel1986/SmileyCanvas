//
//  ViewController.swift
//  Canvas
//
//  Created by Hiren Patel on 3/12/18.
//  Copyright © 2018 Hiren Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var trayOriginalCenter: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    @IBOutlet weak var trayView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UITapGestureRecognizer) {
    
        //  access the translation parameter of the UIPanGestureRecocognizer and store it in a constant.
        let translation = sender.translation(in: view)
        
        //  Get the velocity of the pan gesture recognizer
        var velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            self.trayOriginalCenter = trayView.center
            
            print("Gesture began")
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
            print("Gesture is changing")
        } else if sender.state == .ended {
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayDown
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                }
            }
            
            
            print("Gesture ended")
        }
        
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
    //  access the translation parameter of the UIPanGestureRecocognizer and store it in a constant.
        let translation = sender.translation(in: view)
        
        // create a new image view that contains the same image as the view that was panned on
        if sender.state == .began {
            // imageView now refers to the face that you panned on
            let imageView = sender.view as! UIImageView
            
            // Create a new image view that has the same image as the one you're currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the main view
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the main view, you have to offset the coordinates.
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            // for panning
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            // scale the face out after the start of the dragging
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
            
            print("Gesture began")
        } else if sender.state == .changed {
            // pan the position of the newlyCreatedFace.
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
            
            print("Gesture is changing")
        } else if sender.state == .ended {
            print("Gesture ended")
            // after the face is droped the face will scale back to it initial size
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            // programmatically create and add a UIPanGestureRecognizer to the newly created face
            // in order for the Gesture Recognizer to work
            newlyCreatedFace.isUserInteractionEnabled = true
            let addGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceFromTheMainView(sender:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(addGestureRecognizer)
        }
    }
    
    @objc func didPanFaceFromTheMainView(sender: UIPanGestureRecognizer) {
        NSLog("Paned from the main View")
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            // scale the face out after the start of the dragging
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        }
            
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
            
        else if sender.state == .ended {
            // after the face is droped the face will scale back to it initial size
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
    }

    
    
    
}

