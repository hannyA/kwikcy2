//
//  SigninViewController.swift
//  PopIn
//
//  Created by Hanny Aly on 4/30/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    
    let image = UIImageView(image: UIImage(named: "mad-men-1"))
    
    var facebookButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let heightPosition = UIScreen.mainScreen().bounds.size.height * (4.0 / 5)
//        let heightPosition = UIScreen.mainScreen().bounds.size.height - position
        let buttonSize = CGRectMake(0, heightPosition, view.frame.width, view.frame.height)
        facebookButton = UIButton(frame: buttonSize)
        facebookButton?.imageView
        
        
        //Blur effect
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        blurEffectView.frame = (facebookButton?.bounds)!

        // Vibrancy Effect

        let vibrancy = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .ExtraLight))
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancy)
        vibrancyEffectView.frame = (facebookButton?.bounds)!

        
        let label = UILabel(frame: vibrancyEffectView.bounds)
        label.text = "hello"

        
        view.addSubview(image)
        image.contentMode = .ScaleAspectFill

        
        view.addSubview(facebookButton!)
        facebookButton?.addSubview(blurEffectView)
     
        vibrancyEffectView.addSubview(label)
        blurEffectView.addSubview(vibrancyEffectView)

    

        
    }
    
    override func viewWillLayoutSubviews() {
        image.frame = view.bounds
        
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
