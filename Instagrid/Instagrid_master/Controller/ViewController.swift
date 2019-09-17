//
//  ViewController.swift
//  Instagrid_master
//
//  Created by Caroline Zaini on 02/08/2019.
//  Copyright © 2019 Caroline Zaini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var viewToShare: LayoutView!
    @IBOutlet weak var swipeStackView: UIStackView!
    
    // MARK: - Properties
    private var _imageTapped: UIImageView?
    // Initialize the ImagePickerController and Effects.
    private let _imagePicker = UIImagePickerController()
    private var _effects = Effects()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To handle events in ViewController for the UIImagePickerController .
        _imagePicker.delegate = self
        viewToShare.defaultLayout()
        _effects.shadow(viewToShare)
        swipeDirection()
    }
    
    // MARK: Actions
    @IBAction func tapGridButton(_ sender: UIButton) {
        viewToShare.gridButtonSelected(sender)
    }
    /// Connexion with 4 tapGestures on storyboard.
    @IBAction func tapToPickPhoto(_ sender: UITapGestureRecognizer) {
        tapGesture(sender)
    }
    
    // MARK: - Methods
    /// Method for tapGesture.
    private func tapGesture(_ sender: UITapGestureRecognizer) {
        viewToShare.mainCollection.forEach { image in
            // If the user touch the image. Look at the centroid of the touches involved for the tap gesture.
            let touchPoint = sender.location(in: image)
            if image.point(inside: touchPoint, with: nil) {
                _imageTapped = image
                alertSelectSourcePhotos()
            }
        }
    }
    
    /// Alert to select the source, Library or Camera.
    private func alertSelectSourcePhotos() {
        // Initialize the UIAlertController.
        let alertController = UIAlertController(title: "Import a photo", message: "Choose a source", preferredStyle: .alert)
        // Add an action to the alert. Then the action openLibrary in the closure will be executed.
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.openLibrary()
        }))
        // Add an action to the alert and open Camera.
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.openCamera()
        }))
        // Add the cancel action.
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        // Display it to the user.
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Select photos from library.
    private func openLibrary() {
        _imagePicker.sourceType = .photoLibrary
        _imagePicker.allowsEditing = true
        present(_imagePicker, animated: true, completion: nil)
    }
    
    /// Use camera to take pictures.
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            _imagePicker.sourceType = .camera
            present(_imagePicker, animated: true, completion: nil)
        } else {
            self.presentAlert(title: "Ooops", message: "You don't have a camera", isShareAlert: false)
        }
    }
    
    /// Add the swipe gesture for each direction.
    private func swipeDirection() {
        // The swipeGesture only listen to two directions up and left.
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .left]
        directions.forEach { direction in
            // Initialisation of the swipeGestureRecognizer and add the gesture to our view "swipStackView".
            let _swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
            _swipeGesture.direction = direction
            swipeStackView.addGestureRecognizer(_swipeGesture)
        }
    }
    
    /// Handle the gesture for the swipe according to device orientation.
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up && UIDevice.current.orientation.isPortrait {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.swipeMoveUp(stackview: self.swipeStackView)
            }) { (finished) in
                self.swipeMoveBack(stackview: self.swipeStackView)
            }
                conditionsToShare()
        } else if gesture.direction == .left && UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.swipeMoveLeft(stackview: self.swipeStackView)
            }) { (finished) in
                self.swipeMoveBack(stackview: self.swipeStackView)
            }
                conditionsToShare()
        }
    }
    
    /// Define translations for the swipe movement.
    private func swipeMoveUp(stackview: UIStackView) {
        stackview.transform = CGAffineTransform(translationX: 0, y: -40)
    }
    private func swipeMoveLeft(stackview: UIStackView) {
        stackview.transform = CGAffineTransform(translationX: -40, y: 0)
    }
    private func swipeMoveBack(stackview: UIStackView) {
        stackview.transform = .identity
    }
    
    /// Conditions to share when the user swipe.
    private func conditionsToShare() {
        if viewToShare.isMissingPhoto() {
            presentAlert(title: "Oups!", message: "Some photos are missing", isShareAlert: false)
        } else {
            self.share()
        }
    }

    /// Share the viewToShare.
    private func share() {
        // Convert the image.
        if let image = convertToImage(view: viewToShare) {
            let shareContent = [image]
            let activityController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
            // Inside this closure we can check the activity type.
            activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in if completed {
                    self.presentAlert(title: "🤘", message: "You're image have been shared with succes", isShareAlert: true)
                    self._effects.blur(self.viewToShare)
                }
            }
            present(activityController, animated: true, completion: nil)
        }
    }
    
    /// Convert the viewToShare.
    private func convertToImage(view: UIView) -> UIImage? {
        // Create a context for the view.
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: viewToShare.bounds, afterScreenUpdates: true)
        // give a context and extract a UIImage from the rendering.
        if let context = UIGraphicsGetCurrentContext(), let getImage = UIGraphicsGetImageFromCurrentImageContext() {
            view.layer.render(in: context)
            // when it finished, free up the memory from your rendering.
            UIGraphicsEndImageContext()
            return getImage
        }
        return nil
    }

}

extension ViewController {
    
    private func presentAlert(title: String, message: String, isShareAlert: Bool) {
        // Create the alert controller.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Settings button.
        let answer = UIAlertAction(title: "OK", style:  .default, handler: { (action: UIAlertAction!) in
            if isShareAlert {
                self.resetLayout()
            }
        })
        // Add the action.
        alertController.addAction(answer)
        // Show the alert.
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Reset the default layout.
    private func resetLayout() {
        self.viewToShare.resetImageLayout()
        self._effects.defaultLayoutAnimation(viewToShare)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     // It gives the image selected by the user. The constant "photoToLoad" is the image selected.
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photoToLoad = _imageTapped else { return }
        // if the image is edited with "allowsEditing" and if it's an UIImage.
        if let editedImage = info[.editedImage] as? UIImage {
            photoToLoad.image = editedImage
            photoToLoad.contentMode = .scaleAspectFill
          // If the image is original.
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoToLoad.image = originalImage
            photoToLoad.contentMode = .scaleAspectFill

        }
        // CLose the picker.
        dismiss(animated: true, completion: nil)
    }
}
