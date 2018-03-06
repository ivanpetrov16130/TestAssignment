//
//  InstitutionDetailsViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit

class InstitutionDetailsViewController: UIViewController, BasicView, Alertable {
  typealias Interactor = InstitutionDetailsInteractor
  typealias ViewModel  = InstitutionDetailsViewModel
  
  enum State {
    case viewDidLoad
    case viewDidClose
    case mapDidOpen
  }
  
  
  let interactor: Interactor
  let viewModel: ViewModel
  
  let scrollView: UIScrollView = UIScrollView(frame: .zero)
  
  required init(interactor: InstitutionDetailsInteractor, viewModel: InstitutionDetailsViewModel) {
    self.interactor = interactor
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func loadView() {
    super.loadView()
    view.backgroundColor = .yellow
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    interactor.computeState(for: .viewDidLoad)
  }
  
//  @objc func btnTapped() {
//    interactor.computeState(for: .viewDidClose)
//  }
  
}

extension InstitutionDetailsViewController: Autolayouted {
  var viewHierarchy: ViewHierarchy {
    return ViewHierarchy.complex(UIView(),
                                 constrainted: { $0.edges.pinToSafeArea(of: self) },
                                 subhierarchy: [
                                  ViewHierarchy.complex(scrollView,
                                                        constrainted: { $0.edges.pinToSuperview() },
                                                        subhierarchy: )
      ])
      
//      .plain(scrollView) {
//
//    }
  }
  
  
}

