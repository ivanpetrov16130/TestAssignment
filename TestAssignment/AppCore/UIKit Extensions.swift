//
//  UIKit Extensions.swift
//  TestAssignment
//
//  Created by Ivan on 10.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit


protocol Reusable {
  static var reuseId: String { get }
}

extension Reusable {
  static var reuseId: String { return String(describing: Self.self) }
}

extension UICollectionReusableView: Reusable {}
extension UITableViewCell: Reusable {}
extension UITableView {
  func register<ReusableCell: UITableViewCell>(reusableCellClass: ReusableCell.Type) {
    self.register(reusableCellClass.self, forCellReuseIdentifier: reusableCellClass.reuseId)
  }
}


protocol Alertable {
  func alert(about error: Error)
}

extension Alertable where Self: UIViewController {
  func alert(about error: Error) {
    let alertViewController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
    self.present(alertViewController, animated: true)
  }
}

