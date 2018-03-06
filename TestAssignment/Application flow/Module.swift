//
//  Module.swift
//  TestAssignment
//
//  Created by Ivan on 03.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Swinject

enum ModuleOutcome<T> {
  case cancelled
  case finished(result: T)
}


protocol Module: class {
  
  typealias ViewImplementation = UIViewController
  associatedtype BaseView: UIViewController
  associatedtype IncomeData
  associatedtype OutcomeData
  
  var servicesContainer: Container { get }
  var interactorsContainer: Container { get }
  var viewModelsContainer: Container { get }
  var viewsContainer: Container { get }
  weak var applicationFlow: ApplicationFlow? { get }
  
  var startupView: BaseView { get }
  
  var transitioned: TransitionType? { get set }
  
  var incomeData: IncomeData { get }
  
  func run<PreviosView: ViewImplementation>(basedOn previosView: PreviosView, transitioned: TransitionType)
  
  func finish(outcome: ModuleOutcome<OutcomeData>)
  
}

extension Module {
  
  func run<PreviosView: ViewImplementation>(basedOn previosView: PreviosView, transitioned: TransitionType) {
    self.transitioned = transitioned
    switch transitioned {
    case .modally: DispatchQueue.main.async { previosView.present(self.startupView, animated: true) }
    case .pushing: DispatchQueue.main.async { previosView.navigationController?.pushViewController(self.startupView, animated: true) }
    }
  }
  
  func finish(outcome: ModuleOutcome<OutcomeData>) {
    switch outcome {
    case .cancelled: applicationFlow?.close(module: self)
    case .finished(result: let result): applicationFlow?.finish(module: self, with: result)
    }
  }
  
  
}
