//
//  InstitutionDetailsViewModel.swift
//  TestAssignment
//
//  Created by iOS Developer 1 on 06.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation


class InstitutionDetailsViewModel: BasicViewModel {
  
  typealias View = InstitutionDetailsViewController
  
  let interactor: View.Interactor
  
  required init(interactor: View.Interactor) {
    self.interactor = interactor
  }
  
}
