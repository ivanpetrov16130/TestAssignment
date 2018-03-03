//
//  ViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit

class InstitutionsViewController: UIViewController {
  
  let viewModel: InstitutionsViewModel
  
  let btn = UIButton()
  
  init(viewModel: InstitutionsViewModel) {
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
  
  @objc func btnTapped() {
    viewModel.showInstitution(at: IndexPath(row: 0, section: 0))
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }


}


