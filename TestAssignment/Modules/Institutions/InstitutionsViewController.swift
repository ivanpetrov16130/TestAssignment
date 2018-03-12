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
  
  enum Event {
    case viewDidLoad
    case institutionDidSelected(atIndex: Int)
  }
  
  typealias Interactor = InstitutionsInteractor
  typealias ViewModel = InstitutionsViewModel
  
  let interactor: Interactor
  let viewModel: ViewModel
  let disposeBag = DisposeBag()
  
  let backgroundView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "bgackgroundImage")).styled(with: InstitutionsViewStyle.background)
  let institutionsView: UITableView = UITableView(frame: .zero, style: .plain).styled(with: InstitutionsViewStyle.institutions)
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
  
  required init(interactor: InstitutionsInteractor, viewModel: InstitutionsViewModel) {
    self.interactor = interactor
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .clear
    navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.757715732, green: 0.3135699868, blue: 1, alpha: 1)
    navigationItem.title = "Организации"
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
    }
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
    
    viewModel.errorDataSource
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] error in
        if let error = error {
          self.alert(about: error)
        } else {
          self.presentedViewController?.dismiss(animated: true) // TODO: check if works
        }
      })
      .disposed(by: disposeBag)
    
    interactor.computeState(for: .viewDidLoad)
  }

}

extension InstitutionsViewController: Autolayouted {  
  
  var viewHierarchy: ViewHierarchy {
    return .view(view,
                 subhierarchy: [
                  .view(backgroundView, subhierarchy: nil),
                  .view(institutionsView, subhierarchy: nil),
                  .view(activityIndicator, subhierarchy: nil)
      ]
    )
  }
  
  var autolayoutConstraints: Constraints {
    return Constraints(for: backgroundView, institutionsView, activityIndicator) {
      $0.edges.pinToSafeArea(of: self)
      $1.edges.pinToSafeArea(of: self)
      $2.center.alignWithSuperview()
    }
  }
  
}

