//
//  ViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Yalta
import RxSwift

class InstitutionsViewController: UIViewController, BasicView, Alertable {
  
  enum State {
    case viewDidLoad
    case institutionDidSelected(atIndex: Int)
  }
  
  typealias Interactor = InstitutionsInteractor
  typealias ViewModel = InstitutionsViewModel
  
  let interactor: Interactor
  let viewModel: ViewModel
  let disposeBag = DisposeBag()
  
  let institutionsView: UITableView = UITableView(frame: .zero, style: .plain).styled(with: InstitutionsViewStyles.institutions)
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
  
  required init(interactor: InstitutionsInteractor, viewModel: InstitutionsViewModel) {
    self.interactor = interactor
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
    
    viewModel.institutionsDataSource
      .bind(to: institutionsView.rx.items(cellIdentifier: InstitutionCell.reuseId, cellType: InstitutionCell.self)) {
        index, institution, cell in
        cell.nameLabel.text = institution.name
        cell.descriptionLabel.text = institution.introDescription
        cell.ratingLabel.text = "\(institution.rating)"
      }
      .disposed(by: disposeBag)
    
    institutionsView.rx.itemSelected
      .subscribe(onNext: { [unowned self] indexPath in
        self.interactor.computeState(for: .institutionDidSelected(atIndex: indexPath.row))
      })
      .disposed(by: disposeBag)
    
    viewModel.isActivityIndicatorActive
      .bind(to: activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    interactor.computeState(for: .viewDidLoad)
  }

}

extension InstitutionsViewController: Autolayouted {
  var viewHierarchy: ViewHierarchy {
    return ViewHierarchy.plain(institutionsView, constrainted: { $0.edges.pinToSafeArea(of: self) } )
  }
}

