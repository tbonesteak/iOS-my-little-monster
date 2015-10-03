//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Jon on 9/22/15.
//  Copyright © 2015 Jon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView! // skull 1
    @IBOutlet weak var penalty2Img: UIImageView! // skull 2
    @IBOutlet weak var penalty3Img: UIImageView! // skull 3
    
    let DIM_ALPHA: CGFloat = 0.2  // 0.2 makes the images appear see through. 1.0 is the normal standard, anything less makes it increasingly see through.
    let OPAQUE: CGFloat = 1.0 // Opaque means fully visible. 1.0 is a fully opaque image
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA  // alpha makes the images appear see through.
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        startTimer()
 
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()    // If there is any existing timer happening, stop that so that we can start a new one. This is a safety measure.
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true) // Every 3 seconds, call the function changeGameState.
    }
    
    func changeGameState() {  // Make the skulls see through to visible
        
        penalties++  // Add 1 to the penalty
        
        if penalties == 1 {
            penalty1Img.alpha = OPAQUE;
            penalty2Img.alpha = DIM_ALPHA
        } else if penalties == 2 {
            penalty2Img.alpha = OPAQUE
            penalty3Img.alpha = DIM_ALPHA
        } else if penalties >= 3 {
            penalty3Img.alpha = OPAQUE
        } else {
            penalty1Img.alpha = DIM_ALPHA
            penalty2Img.alpha = DIM_ALPHA
            penalty3Img.alpha = DIM_ALPHA
        }
        
        if penalties >= MAX_PENALTIES {
            gameOver()
        }
        
    }

    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
    }

}
