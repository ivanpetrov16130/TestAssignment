//
//  InstitutionDetailsViewController.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import RxSwift
import Yalta


class InstitutionDetailsViewController: UIViewController, BasicView, Alertable {
  typealias Interactor = InstitutionDetailsInteractor
  typealias ViewModel  = InstitutionDetailsViewModel
  
  enum State {
    case viewDidLoad
    case viewDidClose
    case mapDidOpenForAddress(at: Int)
  }
  
  
  let interactor: Interactor
  let viewModel: ViewModel
  let disposeBag = DisposeBag()
  
  let scrollView: UIScrollView = UIScrollView(frame: .zero)
  let contentView: UIView = UIView(frame: .zero)
  
  let closeButton = UIButton(type: UIButtonType.infoDark)
  let imageView: UIImageView = UIImageView().styled(with: InstitutionDetailsStyle.image)
  let nameLabel: UILabel = UILabel().styled(with: InstitutionDetailsStyle.name)
  let ratingLabel: UILabel = UILabel().styled(with: InstitutionDetailsStyle.rating)
  let descriptionLabel: UILabel = UILabel().styled(with: InstitutionDetailsStyle.description)
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  let addressesView: UITableView = UITableView(frame: .zero, style: .plain).styled(with: InstitutionDetailsStyle.addresses)
  
  var addressesViewHeightConstraint: NSLayoutConstraint?
  
  required init(interactor: InstitutionDetailsInteractor, viewModel: InstitutionDetailsViewModel) {
    self.interactor = interactor
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func loadView() {
    super.loadView()
    view.backgroundColor = .yellow
    
    buildViewHierarchyWithConstraints()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Observable.zip(// TODO: describe wtf is that
      viewModel.institutionAddressesDataSource,
      addressesView.rx.willDisplayCell.skipWhile{ $1.row < self.addressesView.numberOfRows(inSection: 0) - 1 }
      )
      .subscribe(onNext: { (_, _) in
        self.addressesViewHeightConstraint?.isActive = false
        self.addressesViewHeightConstraint = self.addressesView.al.height.set(self.addressesView.contentSize.height)
        self.scrollView.layoutIfNeeded()
      })
      .disposed(by: disposeBag)
    
    viewModel.institutionAddressesDataSource
      .bind(to: addressesView.rx.items(cellIdentifier: InstitutionAddressCell.reuseId, cellType: InstitutionAddressCell.self)) {
        [unowned self] index, address, cell in
        cell.addressLabel.text = address.address
        cell.timetableLabel.text = address.timetable
        cell.mapTransitionButton.rx.tap
          .subscribe(onNext: { _ in
            self.interactor.computeState(for: .mapDidOpenForAddress(at: index))
          })
        .disposed(by: cell.disposeBag)
      }
      .disposed(by: disposeBag)
    
    viewModel.institutionImageDataSource
      .bind(to: imageView.rx.image)
      .disposed(by: disposeBag)
    
    viewModel.institutionNameDataSource
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.institutionRatingDataSource
      .bind(to: ratingLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.institutionDescriptionDataSource
      .bind(to: descriptionLabel.rx.text)
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
    
    
    closeButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.interactor.computeState(for: .viewDidClose)
      })
      .disposed(by: disposeBag)
    
    interactor.computeState(for: .viewDidLoad)
  }
  
}


extension InstitutionDetailsViewController: Autolayouted {
  var viewHierarchy: ViewHierarchy {
    return .view(view,
                 subhierarchy: [
                  .view(closeButton, subhierarchy: nil),
                  .view(scrollView,
                        subhierarchy: [
                          .view(contentView,
                                subhierarchy: [
                                  .view(imageView, subhierarchy: nil),
                                  .view(nameLabel, subhierarchy: nil),
                                  .view(ratingLabel, subhierarchy: nil),
                                  .view(descriptionLabel, subhierarchy: nil),
                                  .view(addressesView, subhierarchy: nil),
                                  .view(activityIndicator, subhierarchy: nil)
                            ])
                    ])
                  
      ])
  }
  
  var autolayoutConstraints: Constraints {
    
    view.bringSubview(toFront: closeButton)
    
    return Constraints(for: closeButton, scrollView, contentView, imageView, nameLabel, ratingLabel, descriptionLabel, addressesView, activityIndicator) {
      
      closeButton, scrollView, contentView, imageView, nameLabel, ratingLabel, descriptionLabel, addressesView, activityIndicator in
      
      closeButton.left.align(with: imageView.left)
      closeButton.top.align(with: imageView.top)
      closeButton.size.set(CGSize(width: 40, height: 40))
      
      scrollView.edges.pinToSafeArea(of: self)
      
      contentView.width.match(view.al.width)
      contentView.edges(.top, .left, .right).pinToSuperview()
      
      imageView.edges(.top, .left, .right).pinToSuperview()
      imageView.height.match(view.al.height, multiplier: 0.4)
      
      nameLabel.top.align(with: imageView.bottom, offset: 16)
      nameLabel.edges(.left, .right).pinToSuperview()
      
      ratingLabel.top.align(with: nameLabel.bottom, offset: 8)
      ratingLabel.edges(.left, .right).pinToSuperview()
      
      descriptionLabel.top.align(with: ratingLabel.bottom, offset: 8)
      descriptionLabel.edges(.left, .right).pinToSuperview()
      
      addressesView.top.align(with: descriptionLabel.bottom, offset: 8)
      addressesView.edges(.left, .right).pinToSuperview()
      addressesViewHeightConstraint = addressesView.height.match(view.al.height)
      addressesView.bottom.align(with: scrollView.bottom, offset: -8)
      addressesView.bottom.pinToSuperview()
      
      activityIndicator.center.align(with: view.al.center)
      
    }
    
  }
  
}

