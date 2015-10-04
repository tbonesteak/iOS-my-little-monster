//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Jon on 9/22/15.
//  Copyright © 2015 Jon. All rights reserved.
//

import UIKit
import AVFoundation // imports the code that has the audio player

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
    var timer: NSTimer!;
    var monsterHappy = false;
    var currentItem: UInt32 = 0;  // 32 Integer can hold more values.
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA  // alpha makes the images appear see through.
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        // initialize the audio files, and also guarantee that they will work and return something
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
        
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay() // prepares to play the song
            musicPlayer.play() // plays the theme music
            
            sfxBite.prepareToPlay();
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay();
        
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
 
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {  //play the heart sound if 0, otherwise play the bite sound
            sfxHeart.play();
        } else {
            sfxBite.play();
        }
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()    // If there is any existing timer happening, stop that so that we can start a new one. This is a safety measure.
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true) // Every 3 seconds, call the function changeGameState.
    }
    
    func changeGameState() {  // Make the skulls see through to visible
        
        if !monsterHappy {
            penalties++  // Add 1 to the penalty
            sfxSkull.play() // play the skull sound
            
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
        
        let rand = arc4random_uniform(2) // gives a random number from the range you give it. This will be 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA;
            foodImg.userInteractionEnabled = false; // prevents the user from dragging around the image. It's dimmed out now, so don't use it!
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true;
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false;
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true;
        }
        
        currentItem = rand
        monsterHappy = false;
        
    }

    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play() // play death sound effect
    }

}
