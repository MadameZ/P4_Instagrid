//
//  Effects.swift
//  Instagrid_master
//
//  Created by Caroline Zaini on 02/08/2019.
//  Copyright © 2019 Caroline Zaini. All rights reserved.
//

import UIKit
import AVFoundation

class Effects: UIView {
    var blurView = UIVisualEffectView()
    var audioPlayer = AVAudioPlayer()
    
    func defaultLayoutAnimation(_ view: LayoutView) {
        // reset any changes, increase the scale and animate it.
        view.transform = .identity
        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [], animations: {
            view.transform = .identity
        })
    }
    
    func shadow(_ view: LayoutView) {
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.5
        // sets how far away from the view the shadow should be, to give a 3D offset effect.
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func blur(_ view: LayoutView) {
        self.blurView.frame = view.bounds
        view.addSubview(self.blurView)
        UIView.animate(withDuration: 0.4, animations: {
            self.blurView.effect = UIBlurEffect(style: .dark)
        }) { (finished) in
            self.blurView.removeFromSuperview()
        }
    }
    
    func soundShare() {
        let sound = Bundle.main.path(forResource: "Sample", ofType: "wav")
        do {
            guard let soundPlay = sound else { return }
           audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPlay))
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    
}
