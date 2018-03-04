//
//  InstitutionDetailsViewModel.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation

protocol InstitutionDetailsViewModel: ViewModel {
  weak var holderModule: InstitutionDetailsModule? { get }
  
  init(holderModule: InstitutionDetailsModule, provider: InstitutionsProvider, institutionId: InstitutionDetailsModule.IncomeData)
  
  func closeDetails()
}

struct BasicInstitutionDetailsViewModel: InstitutionDetailsViewModel {

  weak var holderModule: InstitutionDetailsModule?
  
  let institutionId: InstitutionDetailsModule.IncomeData
  
  init(holderModule: InstitutionDetailsModule, provider: InstitutionsProvider, institutionId: InstitutionDetailsModule.IncomeData) {
    self.holderModule = holderModule
    self.institutionId = institutionId
  }
  
  func closeDetails() {
    print(institutionId)
    holderModule?.finish(outcome: .finished(result: ()))
  }
  
  
}
