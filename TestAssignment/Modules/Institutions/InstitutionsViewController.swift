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
  
  typealias ViewModel = InstitutionsViewModel
  
  let viewModel: ViewModel
  let disposeBag = DisposeBag()
  
  let institutionsView: UITableView = UITableView(frame: .zero, style: .plain).styled(with: InstitutionsViewStyles.institutions)
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
  
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
    
    viewModel.state.subscribe(onNext: { [unowned self] state in
      switch state {
      case .loadingInstitutions:
        self.activityIndicator.startAnimating()
      case .loaded(institutions: let institutions):
        self.activityIndicator.stopAnimating()
        Observable.just(institutions).bind(to: self.institutionsView.rx.items(cellIdentifier: InstitutionCell.reuseId, cellType: InstitutionCell.self)) {
          index, institution, institutionCell in
          institutionCell.nameLabel.text = institution.name
          institutionCell.descriptionLabel.text = institution.introDescription
          institutionCell.ratingLabel.text = "\(institution.rating)"
        }
        .disposed(by: self.disposeBag)
        self.institutionsView.reloadData()
      case .failedLoading(error: let error):
        self.activityIndicator.stopAnimating()
        self.alert(about: error)
      default:
        self.activityIndicator.stopAnimating()
      }
    })
    .disposed(by: disposeBag)
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

