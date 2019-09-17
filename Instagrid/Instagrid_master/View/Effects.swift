//
//  Effects.swift
//  Instagrid_master
//
//  Created by Caroline Zaini on 02/08/2019.
//  Copyright © 2019 Caroline Zaini. All rights reserved.
//

import UIKit


class Effects: UIView {
    
    var blurView = UIVisualEffectView()
    
    func shadow(_ view: LayoutView) {
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.5
        // To give a 3D offset effect. Sets how far away from the view the shadow should be, .
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
    
    func defaultLayoutAnimation(_ view: LayoutView) {
        // Reset any changes with the property transform, increase the scale and animate it.
        view.transform = .identity
        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: [], animations: {
            view.transform = .identity
        })
    }
}
