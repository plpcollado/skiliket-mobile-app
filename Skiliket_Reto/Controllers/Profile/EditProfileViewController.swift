//
//  EditProfileViewController.swift
//  Skiliket_Reto
//
//  Created by Pedro Luis Pérez Collado on 08/10/24.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var profileImageViewEdit: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    // Variables to hold the profile and the image passed from ProfileViewController
    var profile: Profile?
    var profileImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure profileImageViewEdit is circular
        makeProfileImageViewCircular()
        
        // Set the profile view to be rounded
        profileContainerView.layer.cornerRadius = 20  // Adjust the radius as needed
        profileContainerView.layer.masksToBounds = true
        
        // Populate the fields with profile data passed from ProfileViewController
        if let profile = profile {
            usernameLabel.text = profile.username
            titleTextField.text = profile.contactInfo.title
            emailTextField.text = profile.contactInfo.email
            phoneTextField.text = profile.contactInfo.phone
            addressTextField.text = profile.contactInfo.address
        }

        // Display the profile image passed from ProfileViewController
        if let image = profileImage {
            profileImageViewEdit.image = image
        } else {
            profileImageViewEdit.image = UIImage(systemName: "person.crop.circle")
        }

        // Set the text fields' delegate to self to handle "Done" button functionality
        titleTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self

        // Add tap gesture to dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // Adjust the view position when the keyboard frame changes
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            let isKeyboardShowing = keyboardFrame.origin.y < UIScreen.main.bounds.height

            // If the keyboard is showing, move the view up; otherwise, move it back down
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = isKeyboardShowing ? -keyboardHeight / 7 : 0
            }
        }
    }
    
    // Make profileImageView circular by adjusting cornerRadius dynamically
    func makeProfileImageViewCircular() {
        let minDimension = min(profileImageViewEdit.frame.size.width, profileImageViewEdit.frame.size.height)
        profileImageViewEdit.layer.cornerRadius = minDimension / 2
        profileImageViewEdit.clipsToBounds = true
        profileImageViewEdit.contentMode = .scaleAspectFill
    }
    
    // Dismiss the keyboard when tapping "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Hide the keyboard
        return true
    }

    // Dismiss the keyboard when tapping outside of the text fields
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Edit Photo Action
    @IBAction func editPhotoTapped(_ sender: UIButton) {
        // Create and present an image picker to choose an image from the gallery
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true  // Allow the user to edit the selected image (crop, etc.)
        self.present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the edited image (or the original if no editing was done)
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageViewEdit.image = editedImage  // Set the new image temporarily
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageViewEdit.image = originalImage
        }
        
        // Ensure the image stays circular after selection
        makeProfileImageViewCircular()
        
        picker.dismiss(animated: true, completion: nil)  // Dismiss the image picker
    }


    // Action for when the "Save" button is pressed
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        // Verifica si el campo de usernameTextField está vacío o contiene solo espacios en blanco
        if titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: "Username Required", message: "Please enter a valid username before saving.")
        } else {
            // Show an alert to simulate data saving
            let alert = UIAlertController(title: "Data Saved", message: "Your changes have been saved successfully.", preferredStyle: .alert)
            
            // Add an action to the alert that returns to the previous view (ProfileViewController)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                // Navigate back to ProfileViewController after saving (simulate data save)
                self.navigationController?.popViewController(animated: true)
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
    }

    // Función para mostrar una alerta personalizada
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


