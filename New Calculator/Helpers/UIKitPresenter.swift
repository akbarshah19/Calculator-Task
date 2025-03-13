//
//  UIKitPresenter.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 13/03/25.
//

import SwiftUI
import UIKit

struct UIKitPresenter: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
