//
//  ViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Yalta

class InstitutionsViewController: UIViewController, BasicView {
  
  enum State {
    case viewDidLoad
    case institutionDidSelected(atIndex: Int)
  }
  
  typealias ViewModel = InstitutionsViewModel
  
  let viewModel: ViewModel
  
  let institutionsView: UITableView = UITableView(frame: .zero, style: .plain).styled(with: InstitutionsViewStyles.institutions)

  
  required init(viewModel: InstitutionsViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .green
    
    buildViewHierarchyWithConstraints()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.updateViewModelState(for: .viewDidLoad)
  }
  
//  @objc func btnTapped() {
//    viewModel.updateViewModelState(for: .institutionDidSelected(atIndex: 0))
//  }
  

}

extension InstitutionsViewController: Autolayouted {
  var viewHierarchy: ViewHierarchy {
    return ViewHierarchy.plain(institutionsView, constrainted: { $0.edges.pinToSafeArea(of: self) } )
  }
}

