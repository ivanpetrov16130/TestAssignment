//
//  All.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import class RxCocoa.BehaviorRelay


protocol BasicViewModel {
  
  associatedtype View: BasicView
  associatedtype State
  associatedtype HolderModule: Module
  typealias ObservableState = BehaviorRelay<State>
  
  weak var holderModule: HolderModule? { get }
  var viewStatesReactionQueue: DispatchQueue { get }
  var state: ObservableState { get }

  func viewModelState(for viewState: View.State)
  
  static var newViewStatesReactionQueue: DispatchQueue { get }

}

extension BasicViewModel {
  
  static var newViewStatesReactionQueue: DispatchQueue {
    return DispatchQueue(label: "ru.motmom.testassigment.\(String(describing: Self.self))", qos: DispatchQoS.userInteractive)
  }
  
  func updateViewModelState(for viewState: View.State) {
    viewStatesReactionQueue.sync { self.viewModelState(for: viewState) }
  }
  
}


protocol BasicView: class {
  associatedtype ViewModel: BasicViewModel
  associatedtype State
  
  var viewModel: ViewModel { get }
  
  init(viewModel: ViewModel)
  
}

//extension BasicView where Self: UIViewController {
////  init(viewModel: ViewModel) {
////    self.viewModel = viewModel
////    
////  }
//
//}

