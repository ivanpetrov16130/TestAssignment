//
//  InstitutionsViewModel.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import RxSwift


protocol InstitutionsViewModel: ViewModel {
  
  weak var holderModule: InstitutionsModule? { get }
  
  init(holderModule: InstitutionsModule, provider: InstitutionsProvider)
  
  func showInstitution(at indexPath: IndexPath)
}


struct BasicInstitutionsViewModel: InstitutionsViewModel {
  
  private(set) weak var holderModule: InstitutionsModule?
  
  private let provider: InstitutionsProvider
  
  private let disposeBag = DisposeBag()
  
  init(holderModule: InstitutionsModule, provider: InstitutionsProvider) {
    self.holderModule = holderModule
    self.provider = provider
    
    provider.rx.request(.institutions)
      .map([String: Institution].self)
      .map { (keyedInstitutions) -> [Institution] in
        keyedInstitutions.map{ $0.value }
      }
      .subscribe(onSuccess: { (institutions) in
        print(institutions)
        //state.value = .institutionsLoaded(institutions)
      }) { (error) in
        print(error)
        //state.value = .institutionsFailed(error)
      }
      .disposed(by: disposeBag)
  }
  
  func showInstitution(at indexPath: IndexPath) {
    holderModule?.finish(outcome: .finished(result: "id"))
  }
  
  
}
