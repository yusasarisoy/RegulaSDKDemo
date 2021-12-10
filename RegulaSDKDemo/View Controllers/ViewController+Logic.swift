//
//  ViewController+Logic.swift
//  RegulaSDKDemo
//
//  Created by Yuşa on 10.12.2021.
//

import DocumentReader
import UIKit

extension ViewController {

  // MARK: - Regula Functions

  /// Allows to download the database and then scan documents.
  func initializationReader() {
    // getting license
    guard let dataPath = Bundle.main.path(forResource: "regula.license", ofType: nil) else { return }
    guard let licenseData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else { return }

    DispatchQueue.global().async {
      DocReader.shared.prepareDatabase(databaseID: "Full",
                                       progressHandler: { (progress) in
        let progressValue = String(format: "%.1f",
                                   progress.fractionCompleted * 100)
        self.labelInitialization.text = "Downloading database: \(progressValue)%"
      }, completion: { (success, error) in
        if success {
          let config = DocReader.Config(license: licenseData,
                                        licenseUpdateCheck: true,
                                        databasePath: nil)

          DocReader.shared.initializeReader(config: config) { (success, error) in
            DispatchQueue.main.async {
              if success {
                self.activityIndicatorSpinner.stopAnimating()
                self.labelInitialization.isHidden = true
                self.buttonUseCamera.isHidden = false

                // set scenario
                if let firstScenario = DocReader.shared.availableScenarios.first {
                  DocReader.shared.processParams.scenario = firstScenario.identifier
                }
              } else {
                self.activityIndicatorSpinner.stopAnimating()
                self.labelInitialization.text = "Initialization error: \(error?.localizedDescription ?? "unknown")"
                print(error?.localizedDescription ?? "unknown")
              }
            }
          }
        } else {
          self.activityIndicatorSpinner.stopAnimating()
          self.labelInitialization.text = "Database error: \(error?.localizedDescription ?? "unknown")"
          print(error?.localizedDescription ?? "unknown")
        }
      })
    }
  }

  /// Provides to scan documents.
  /// - Parameter sender: The **UIButton** tapped to scan documents.
  @objc func useCameraViewController(_ sender: UIButton) {
    DocReader.shared.showScanner(self) { (action, result, error) in
      switch action {
      case .cancel:
        print("Cancelled by user")
      case .complete:
        print("Completed")
        self.handleResult(result: result)
      case .error:
        print("Error")
        guard let error = error else { return }
        print("Error string: \(error)")
      case .process:
        guard let result = result else { return }
        print("Scaning not finished. Result: \(result)")
      case .morePagesAvailable:
        print("This status couldn't be here, it uses for -recognizeImage function")
      case .processWhiteFlashLight:
        print("Flash light")
      @unknown default:
        break
      }
    }
  }

  /// Serves to collect document information and display it on a **UIAlertController**.
  /// - Parameter result: Keeps the results obtained from the scanned document
  func handleResult(result: DocumentReaderResults?) {
    guard let result = result else { return }

    populatePassportInformation(basedOn: result)

    showDocumentedImage(with: result)
  }

  // MARK: - Helpers

  /// Provides to get whole information of the documented image.
  /// - Parameter result: Stores the information of the documented image.
  private func populatePassportInformation(basedOn result: DocumentReaderResults) {
    /// Holds the passport informations.
    var passportInformation: String {
      var fields = ""

      result.textResult.fields.forEach { textField in
        textField.values.forEach { value in
          fields.append("• \(textField.fieldName): \(value.value)\n")
        }
      }
      return fields
    }

    labelDocumentedImage.text = passportInformation.isEmpty
    ? "No Documented Image"
    : "Documented Image"

    showPassportInformationAlert(with: passportInformation)
  }

  /// Allows the documented image, passport, to be displayed.
  /// - Parameter result: Stores the information of the documented image.
  private func showDocumentedImage(with result: DocumentReaderResults) {
    labelDocumentedImage.isHidden = false
    imageViewDocument.isHidden = false
    imageViewDocument.image = result.getGraphicFieldImageByType(fieldType: .gf_DocumentImage, source: .rawImage)
  }

  /// Provides to show information of the documented image on a **UIAlertController**.
  /// - Parameter message: Holds the passport informations.
  private func showPassportInformationAlert(with message: String) {
    let alert = UIAlertController(title: message.isEmpty
                                  ? "No Passport Information"
                                  : "Passport Information",
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default))
    present(alert,
            animated: true)
  }

  /// Provides to retrieve information as **Dictionary** from the documented image that the user picked.
  func convertInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
  }

  /// Provides to retrieve information from the documented image that the user picked.
  func convertInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    input.rawValue
  }
}
