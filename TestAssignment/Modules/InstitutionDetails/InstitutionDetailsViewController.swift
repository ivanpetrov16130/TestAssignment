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
    
    viewModel.institutionAddressesDataSource
      .bind(to: addressesView.rx.items(cellIdentifier: InstitutionAddressCell.reuseId, cellType: InstitutionAddressCell.self)) {
        [unowned self] index, address, cell in
        cell.addressLabel.text = address.address
        cell.timetableLabel.text = address.timetable
        cell.mapTransitionButton.rx.tap
//          .do(onNext: { (_) in
//            print("mb next")
//          }, onError: { (error) in
//            print("mb err \(error)")
//          }, onCompleted: {
//            print("mb compl")
//          }, onSubscribe: {
//            print("mb subscribe")
//          }, onSubscribed: {
//            print("mb subscriBED")
//          }, onDispose: {
//            print("mb disp")
//          })
          .debug()
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

    addressesView.rx.didScroll
      .subscribe(onNext: { _ in
        print("did scroll")
      })
      .disposed(by: disposeBag)
    
    closeButton.rx.tap
      .subscribe(onNext: { [unowned self] _ in
        self.interactor.computeState(for: .viewDidClose)
      })
      .disposed(by: disposeBag)
    
    interactor.computeState(for: .viewDidLoad)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewdidappear")
    print("sv mask \(scrollView.translatesAutoresizingMaskIntoConstraints)")
  }
  
}

extension InstitutionDetailsViewController: Autolayouted {
  var viewHierarchy: ViewHierarchy {
    return .view(view,
                 subhierarchy: [
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
                    ]),
                    .view(closeButton, subhierarchy: nil)
      ])
  }
  
  var autolayoutConstraints: Constraints {
    
    return Constraints(for: closeButton, scrollView, contentView, imageView, nameLabel, ratingLabel, descriptionLabel, addressesView, activityIndicator) {
      $0.edges(.left, .top).pinToSuperview()
      $0.size.set(CGSize(width: 40, height: 40))
      
      $1.edges.pinToSafeArea(of: self)
      
      $2.top.pinToSuperview()
      $2.left.pinToSuperview()
      $2.width.match(view.al.width)
      
      $3.edges(.top, .left, .right).pinToSuperview()
      $3.height.match(view.al.height, multiplier: 0.4)
      
      $4.top.align(with: $3.bottom, offset: 16)
      $4.edges(.left, .right).pinToSuperview()
      
      $5.top.align(with: $4.bottom, offset: 8)
      $5.edges(.left, .right).pinToSuperview()
      
      $6.top.align(with: $5.bottom, offset: 8)
      $6.edges(.left, .right).pinToSuperview()
      
      $7.top.align(with: $6.bottom, offset: 8).priority = UILayoutPriority(rawValue: 749)
      $7.edges(.left, .right).pinToSuperview()
      $7.height.match($1.height)
      $7.bottom.align(with: $1.bottom, offset: -8)
      
      $8.center.align(with: view.al.center)
    }
    
  }
  
}

