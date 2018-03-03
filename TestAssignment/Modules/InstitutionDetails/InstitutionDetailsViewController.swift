//
//  InstitutionDetailsViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit

class InstitutionDetailsViewController: UIViewController {
  
  let viewModel: InstitutionDetailsViewModel
  
  let btn = UIButton()
  
  init(viewModel: InstitutionDetailsViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .yellow
    
    btn.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 60))
    btn.backgroundColor = .blue
    btn.center = view.center
    btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    
    view.addSubview(btn)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  @objc func btnTapped() {
    viewModel.closeDetails()
  }
  
}


