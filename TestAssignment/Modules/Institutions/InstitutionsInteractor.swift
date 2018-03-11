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
    case failedLoadingInstitutions(error: Error)
    case noInstitutions
  }
  
  let eventsReactionQueue: DispatchQueue = InstitutionsInteractor.newEventsReactionQueue
  private(set) weak var holderModule: InstitutionsModule?
  private let provider: InstitutionsProvider
  private let disposeBag = DisposeBag()
  
  let state: ObservableState = BehaviorRelay(value: .initial)


  required init(holderModule: InstitutionsModule, provider: InstitutionsProvider) {
    self.holderModule = holderModule
    self.provider = provider
  }
  
  func state(for viewState: View.Event) {
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
          self.state.accept(.failedLoadingInstitutions(error: error))
        }
        .disposed(by: disposeBag)
    case .institutionDidSelected(atIndex: let index):
      if case let .loaded(institutions: institutions) = self.state.value,
        institutions.endIndex > index, !(index < institutions.startIndex) {
        holderModule?.finish(outcome: .finished(result: institutions[index].id))
      }
    }
  }

  
  
}
