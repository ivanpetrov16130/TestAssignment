//
//  AutoLayout.swift
//  TestAssignment
//
//  Created by Ivan on 10.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Yalta


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
