//
//  ViewController+Constraints.swift
//  RegulaSDKDemo
//
//  Created by Yuşa on 10.12.2021.
//

import SnapKit
import UIKit

extension ViewController {
  /// Allows to setup constraints of **UIView** elements using SnapKit.
  func setupConstraints() {
    activityIndicatorSpinner.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.width.height.equalTo(45)
    }

    labelInitialization.snp.makeConstraints { make in
      make.top.equalTo(activityIndicatorSpinner.snp.bottom).offset(5)
      make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
    }

    imageViewDocument.snp.makeConstraints { make in
      make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.centerX.centerY.equalToSuperview()
      make.height.equalTo(view.bounds.height / 3)
    }

    labelDocumentedImage.snp.makeConstraints { make in
      make.top.equalTo(imageViewDocument.snp.bottom).offset(20)
      make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
    }

    buttonUseCamera.snp.makeConstraints { make in
      make.top.equalTo(labelDocumentedImage.snp.bottom).offset(40)
      make.centerX.equalToSuperview()
    }
  }
}
