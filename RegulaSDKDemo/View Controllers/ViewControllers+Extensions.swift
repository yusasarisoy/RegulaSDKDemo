//
//  ViewControllers+Extensions.swift
//  RegulaSDKDemo
//
//  Created by Yuşa on 10.12.2021.
//

import DocumentReader
import UIKit

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
