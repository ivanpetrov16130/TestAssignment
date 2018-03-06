//
//  InstitutionsInteractor.swift
//  TestAssignment
//
//  Created by iOS Developer 1 on 06.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class InstitutionsViewModel: BasicViewModel {
  typealias View = InstitutionsViewController
  
  let interactor: View.Interactor
  let disposeBag = DisposeBag()
  
  let isActivityIndicatorActive: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  let institutionsDataSource: BehaviorRelay<[Institution]> = BehaviorRelay(value: [])
  let errorDataSource: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
  let isErrorAlertActive: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  
  required init(interactor: View.Interactor) {
    self.interactor = interactor
    
    interactor.state.subscribe(onNext: { [unowned self] (state) in
      switch state {
      case .loadingInstitutions:
        self.isActivityIndicatorActive.accept(true)
      case .loaded(institutions: let institutions):
        self.isActivityIndicatorActive.accept(false)
        self.institutionsDataSource.accept(institutions)
      case .failedLoading(error: let error):
        self.isActivityIndicatorActive.accept(false)
        self.errorDataSource.accept(error)
      default:
        self.errorDataSource.accept(nil)
      }
    })
      .disposed(by: disposeBag)
  }
  
}
