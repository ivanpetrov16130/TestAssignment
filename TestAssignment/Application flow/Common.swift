//
//  All.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import class RxCocoa.BehaviorRelay
import Yalta

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

enum ViewHierarchy {
  
  typealias ContraintsApplicator = (LayoutProxy<UIView>) -> Void
  
  case plain(UIView, constrainted: ContraintsApplicator)
  case complex(UIView, constrainted: ContraintsApplicator, subhierarchy: [ViewHierarchy])
  
  func build(in superview: UIView) {
    switch self {
    case .plain(let view, constrainted: _):
      superview.addSubview(view)
    case .complex(let view, constrainted: _, subhierarchy: let subhierarchy):
      superview.addSubview(view)
      subhierarchy.forEach{ $0.build(in: view) }
    }
  }
  
  var constraintApplicators: [(view: UIView, constrainted: ContraintsApplicator)] {
    switch self {
    case .plain(let view, constrainted: let constraintsApplicator):
      return [(view: view, constrainted: constraintsApplicator)]
    case .complex(let view, constrainted: let constraintsApplicator, subhierarchy: let subhierarchy):
      return subhierarchy.flatMap { $0.constraintApplicators } + [(view: view, constrainted: constraintsApplicator)]
    }
  }
  
}

protocol Autolayouted {
  
  var viewHierarchy: ViewHierarchy { get }
  
  func buildViewHierarchyWithConstraints()
  
}

extension Autolayouted {
  
  fileprivate func buildViewHierarchyWithConstraints(in view: UIView) {
    let viewHierarchy = self.viewHierarchy
    viewHierarchy.build(in: view)
    viewHierarchy.constraintApplicators.forEach{ $0.constrainted($0.view.al) }
  }
  
}

extension Autolayouted where Self: UIViewController {
  func buildViewHierarchyWithConstraints() { buildViewHierarchyWithConstraints(in: view) }
}

extension Autolayouted where Self: UITableViewCell {
  func buildViewHierarchyWithConstrainsts() { buildViewHierarchyWithConstraints(in: contentView) }
}

extension Autolayouted where Self: UICollectionViewCell {
  func buildViewHierarchyWithConstraints() { buildViewHierarchyWithConstraints(in: contentView) }
}

extension Autolayouted where Self: UIView {
  func buildViewHierarchyWithConstraints() { buildViewHierarchyWithConstraints(in: self) }
}


