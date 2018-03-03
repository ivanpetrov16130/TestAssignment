//
//  InstitutionsViewModel.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation

protocol InstitutionsViewModel: ViewModel {
  
  weak var holderModule: InstitutionsModule? { get }
  
  init(holderModule: InstitutionsModule, networkService: NetworkService)
  
  func showInstitution(at indexPath: IndexPath)
}


struct BasicInstitutionsViewModel: InstitutionsViewModel {
  
  private(set) weak var holderModule: InstitutionsModule?
  
  init(holderModule: InstitutionsModule, networkService: NetworkService) {
    self.holderModule = holderModule
  }
  
  func showInstitution(at indexPath: IndexPath) {
    holderModule?.finish(outcome: .finished(result: "id"))
  }
  
  
}
