//
//  LayoutView.swift
//  Instagrid_master
//
//  Created by Caroline Zaini on 02/08/2019.
//  Copyright © 2019 Caroline Zaini. All rights reserved.
//

import UIKit

/// Define the apparence of the principal layout.
enum Layout {
    case layout1, layout2, layout3
}
/// Define the apparence of the three buttons.
enum Grid {
    case grid1, grid2, grid3
}

class LayoutView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomRightImageview: UIImageView!
    // Outlet collection include each images of the layout.
    @IBOutlet var mainCollection: [UIImageView]!
    
    @IBOutlet private var grid1Button: UIButton!
    @IBOutlet private var grid2Button: UIButton!
    @IBOutlet private var grid3Button: UIButton!
    
    // MARK: - Properties
    var layoutSelected: Layout = .layout2{
        didSet {
            changeLayout(layoutSelected)
        }
    }
    
    var imageGrid: Grid = .grid2 {
        didSet {
            changeImageGrid(imageGrid)
        }
    }
    
    // MARK: - Methods
    /// Define the appearence of layout.
    private func changeLayout(_ layout: Layout) {
        switch layout {
        case .layout1:
            topLeftImageView.isHidden = true
            bottomLeftImageView.isHidden = false
        case .layout2:
            topLeftImageView.isHidden = false
            bottomLeftImageView.isHidden = true
        case .layout3:
            topLeftImageView.isHidden = false
            bottomLeftImageView.isHidden = false
        }
    }
    /// Define the appearence of the button when it selected.
    private func changeImageGrid(_ grid: Grid) {
        switch grid {
        case .grid1: grid1Button.setImage(#imageLiteral(resourceName: "Grid 1 Selected"), for: .selected)
        case .grid2: grid2Button.setImage(#imageLiteral(resourceName: "Grid 2 Selected"), for: .selected)
        case .grid3: grid3Button.setImage(#imageLiteral(resourceName: "Grid 3 Selected"), for: .selected)
        }
    }
    
    /// Called in the viewController by the IBAction.
    func gridButtonSelected(_ sender: UIButton) {
        // Reset all the buttons wich was selected before.
        grid1Button.isSelected = false
        grid2Button.isSelected = false
        grid3Button.isSelected = false
        // Then selected the sender.
        sender.isSelected = true
        // Change the style of the main Collection.
        gridSelected(sender)
    }
    
    /// Change the layout according with image of buttons.
    private func gridSelected(_ button: UIButton) {
        if button == self.grid1Button {
            self.layoutSelected = .layout1
            self.imageGrid = .grid1
        } else if button == self.grid2Button {
            self.layoutSelected = .layout2
            self.imageGrid = .grid2
        } else if button == self.grid3Button {
            self.layoutSelected = .layout3
            self.imageGrid = .grid3
        }
    }
    
    /// Appearence of the default layout.
    func defaultLayout() {
        self.layoutSelected = .layout2
        grid2Button.isSelected = true
        self.imageGrid = .grid2
    }
    /// Appearence of the default image's layout.
    func resetImageLayout() {
        let imageBaseline = UIImage(named: "Plus")
        topLeftImageView.image = imageBaseline
        bottomLeftImageView.image = imageBaseline
        topRightImageView.image = imageBaseline
        bottomRightImageview.image = imageBaseline
        topLeftImageView.contentMode = .center
        bottomLeftImageView.contentMode = .center
        topRightImageView.contentMode = .center
        bottomRightImageview.contentMode = .center
    }
    
    /// Check if the grid is complete before sharing.
    func isMissingPhoto() -> Bool {
        switch layoutSelected {
        case .layout1:
            if topRightImageView.image == #imageLiteral(resourceName: "Plus") ||  bottomRightImageview.image == #imageLiteral(resourceName: "Plus") ||
                bottomLeftImageView.image == #imageLiteral(resourceName: "Plus") {
                return true
            }
        case .layout2:
            if topLeftImageView.image == #imageLiteral(resourceName: "Plus") || topRightImageView.image == #imageLiteral(resourceName: "Plus") || bottomRightImageview.image == #imageLiteral(resourceName: "Plus") {
                return true
            }
        case .layout3:
            if topLeftImageView.image == #imageLiteral(resourceName: "Plus") || topRightImageView.image == #imageLiteral(resourceName: "Plus") || bottomLeftImageView.image == #imageLiteral(resourceName: "Plus") || bottomRightImageview.image == #imageLiteral(resourceName: "Plus") {
                return true
            }
        }
        return false
    }
}
