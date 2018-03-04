//
//  ViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit

class InstitutionsViewController: UIViewController, BasicView {
  
  enum State {
    case viewDidLoad
    case institutionDidSelected(atIndex: Int)
  }
  
  typealias ViewModel = InstitutionsViewModel
  
  let viewModel: ViewModel
  
  let btn = UIButton()
  
  required init(viewModel: InstitutionsViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .green
    
    btn.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 60))
    btn.backgroundColor = .blue
    btn.center = view.center
    btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    
    view.addSubview(btn)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.updateViewModelState(for: .viewDidLoad)
  }
  
  @objc func btnTapped() {
    viewModel.updateViewModelState(for: .institutionDidSelected(atIndex: 0))
  }

}


