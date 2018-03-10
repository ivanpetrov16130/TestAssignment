//
//  File.swift
//  TestAssignment
//
//  Created by Ivan on 10.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit


public struct Style<View: UIView> {
  
  public let style: (View) -> Void
  
  public init(_ style: @escaping (View) -> Void) {
    self.style = style
  }
  
  public func apply(to view: View) -> View {
    style(view)
    return view
  }
  
}

extension UIView {
  
  func styled<View>(with style: Style<View>) -> View {
    guard let view = self as? View else {
      fatalError("Could not apply style for \(View.self) to \(type(of: self))")
    }
    return style.apply(to: view)
  }
  
}
