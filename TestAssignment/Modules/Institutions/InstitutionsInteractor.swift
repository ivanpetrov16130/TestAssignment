//
//  InstitutionsViewModel.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class InstitutionsInteractor: BasicInteractor {

  typealias View = InstitutionsViewController

  enum State {
    case initial
    case loadingInstitutions
    case loaded(institutions: [Institution])
    case failedLoading(error: Error)
    case noInstitutions
  }
  
  let viewStatesReactionQueue: DispatchQueue = InstitutionsInteractor.newViewStatesReactionQueue
  private(set) weak var holderModule: InstitutionsModule?
  private let provider: InstitutionsProvider
  private let disposeBag = DisposeBag()
  
  let state: ObservableState = BehaviorRelay(value: .initial)


  required init(holderModule: InstitutionsModule, provider: InstitutionsProvider) {
    self.holderModule = holderModule
    self.provider = provider
  }
  
  func state(for viewState: View.State) {
    switch viewState {
    case .viewDidLoad:
      state.accept(.loadingInstitutions)
      provider.rx.request(.institutions)
        .map([String: Institution].self)
        .map { (keyedInstitutions) -> [Institution] in
          keyedInstitutions.map{ $0.value }
        }
        .subscribe(onSuccess: { [unowned self] institutions in
          self.state.accept(.loaded(institutions: institutions))
        }) { [unowned self] (error) in
          self.state.accept(.failedLoading(error: error))
        }
        .disposed(by: disposeBag)
    case .institutionDidSelected(atIndex: let index):
      holderModule?.finish(outcome: .finished(result: "id \(index)"))
    }
  }

  
  
}
