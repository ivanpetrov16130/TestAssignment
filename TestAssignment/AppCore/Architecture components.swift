//
//  Module.swift
//  TestAssignment
//
//  Created by Ivan on 03.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Swinject
import class RxCocoa.BehaviorRelay


protocol BasicInteractor {
  
  associatedtype View: BasicView
  associatedtype State
  associatedtype HolderModule: Module
  typealias ObservableState = BehaviorRelay<State>
  
  weak var holderModule: HolderModule? { get }
  var viewStatesReactionQueue: DispatchQueue { get }
  var state: ObservableState { get }
  
  func state(for viewState: View.Event)
  
  static var newViewStatesReactionQueue: DispatchQueue { get }
  
}

extension BasicInteractor {
  
  static var newViewStatesReactionQueue: DispatchQueue {
    return DispatchQueue(label: "ru.motmom.testassigment.\(String(describing: Self.self))", qos: DispatchQoS.userInteractive)
  }
  
  func computeState(for viewState: View.Event) {
    viewStatesReactionQueue.sync { self.state(for: viewState) }
  }
  
}


protocol BasicView: class {
  associatedtype Interactor: BasicInteractor
  associatedtype ViewModel: BasicViewModel
  associatedtype Event
  
  var interactor: Interactor { get }
  var viewModel: ViewModel { get }
  
  init(interactor: Interactor, viewModel: ViewModel)
  
}


protocol BasicViewModel: class {
  associatedtype View: BasicView
  var interactor: View.Interactor { get }
  
  init(interactor: View.Interactor)
}



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
