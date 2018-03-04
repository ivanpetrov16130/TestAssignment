//
//  All.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit

//protocol Injected: class {
//  static var injectionName: String { get }
//}
//
//extension Injected where Self: UIViewController {
//  
//  static var injectionName: String { return String(describing: Self.self) }
//  
//}

protocol ViewModel {
  
  func viewDidLoad()
  
}
  
extension ViewModel {

  func viewDidLoad() {}
  
}
