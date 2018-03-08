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

protocol BasicInteractor {
  
  associatedtype View: BasicView
  associatedtype State
  associatedtype HolderModule: Module
  typealias ObservableState = BehaviorRelay<State>
  
  weak var holderModule: HolderModule? { get }
  var viewStatesReactionQueue: DispatchQueue { get }
  var state: ObservableState { get }

  func state(for viewState: View.State)
  
  static var newViewStatesReactionQueue: DispatchQueue { get }

}

extension BasicInteractor {
  
  static var newViewStatesReactionQueue: DispatchQueue {
    return DispatchQueue(label: "ru.motmom.testassigment.\(String(describing: Self.self))", qos: DispatchQoS.userInteractive)
  }
  
  func computeState(for viewState: View.State) {
    viewStatesReactionQueue.sync { self.state(for: viewState) }
  }
  
}


protocol BasicView: class {
  associatedtype Interactor: BasicInteractor
  associatedtype ViewModel: BasicViewModel
  associatedtype State
  
  var interactor: Interactor { get }
  var viewModel: ViewModel { get }
  
  init(interactor: Interactor, viewModel: ViewModel)
  
}


protocol BasicViewModel: class {
  associatedtype View: BasicView
  var interactor: View.Interactor { get }
  
  init(interactor: View.Interactor)
}


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


protocol Alertable {
  func alert(about error: Error)
}

extension Alertable where Self: UIViewController {
  func alert(about error: Error) {
    let alertViewController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
    self.present(alertViewController, animated: true)
  }
}


enum ViewHierarchy {
  
  case view(UIView, subhierarchy: [ViewHierarchy]?)
  
  private func build(in superview: UIView) {
    switch self {
    case .view(let view, subhierarchy: let subhierarchy):
      superview.addSubview(view)
      subhierarchy?.forEach{ $0.build(in: view) }
    }
  }
  
  func build() { switch self { case .view(let view, subhierarchy: let subhierarchy): subhierarchy?.forEach{ $0.build(in: view) } } }
  
}


protocol Autolayouted {
  
  var viewHierarchy: ViewHierarchy { get }
  
  var autolayoutConstraints: Yalta.Constraints { get }
  
  func buildViewHierarchyWithConstraints()
  
}

extension Autolayouted {
  
  func buildViewHierarchyWithConstraints() {
    viewHierarchy.build()
    _ = autolayoutConstraints
  }
  
}

extension Yalta.Constraints {
  @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem, E: LayoutItem, F: LayoutItem, G: LayoutItem, H: LayoutItem, I: LayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>, LayoutProxy<D>, LayoutProxy<E>, LayoutProxy<F>, LayoutProxy<G>, LayoutProxy<H>, LayoutProxy<I>) -> Void) {
    self.init { closure(a.al, b.al, c.al, d.al, e.al, f.al, g.al, h.al, i.al) }
  }
}
