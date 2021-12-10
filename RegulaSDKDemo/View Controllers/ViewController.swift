//
//  ViewController.swift
//  RegulaSDKDemo
//
//  Created by Yuşa on 9.12.2021.
//

import DocumentReader
import UIKit

class ViewController: UIViewController {

  // MARK: - Properties

  /// Spinning a spinner while downloading the database.
  lazy var activityIndicatorSpinner: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.color = .gray
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)

    return activityIndicator
  }()

  /// Displays the text  "Initializing..." while downloading the database.
  lazy var labelInitialization: UILabel = {
    let label = UILabel()
    label.text = "Initializing..."
    label.textColor = .white
    label.textAlignment = .center
    view.addSubview(label)

    return label
  }()

  /// Displays the text "Documented Image".
  lazy var imageViewDocument: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 12
    imageView.layer.borderColor = UIColor.gray.cgColor
    imageView.layer.borderWidth = 1
    imageView.isHidden = true
    view.addSubview(imageView)

    return imageView
  }()

  /// Displays the text "Documented Image".
  lazy var labelDocumentedImage: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.isHidden = true
    view.addSubview(label)

    return label
  }()

  /// Allows scanning the image that will be documented.
  lazy var buttonUseCamera: UIButton = {
    let button = UIButton()
    button.setTitle("Tap to scan document",
                    for: .normal)
    button.setTitleColor(.white,
                         for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.addTarget(self,
                     action: #selector(useCameraViewController),
                     for: .touchUpInside)
    view.addSubview(button)

    return button
  }()

  /// Provides to handle picked image.
  private let imagePicker = UIImagePickerController()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .black

    setupConstraints()

    initializationReader()
  }
}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController
                                                                    .InfoKey: Any]) {
    let info = convertInfoKeyDictionary(info)

    if let image = info[convertInfoKey(UIImagePickerController
                                        .InfoKey
                                        .originalImage)] as? UIImage {
      self.dismiss(animated: true, completion: {
        DocReader.shared.recognizeImage(image,
                                        completion: { (action, result, error) in
          if action == .complete,
             let result = result {
            self.handleResult(result: result)
          } else if action == .error {
            guard let error = error else { return }
            print("An error occured while recognizing image: \(error)")
          }
        })
      })
    } else {
      self.dismiss(animated: true, completion: nil)
      print("Something went wrong")
    }
  }
}
