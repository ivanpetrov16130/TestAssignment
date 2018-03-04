//
//  ApplicationFlow.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import Swinject


enum TransitionType {
  case modally
  case pushing
}

class ApplicationFlow {
  
  private let servicesContainer: Container = {
    let container = Container()
    container.register(InstitutionsProvider.self) { _ in
      InstitutionsProvider()
    }
    return container
  }()
  
  private lazy var modulesContainer: Container = {
    let container = Container(parent: servicesContainer)
    container.register(InstitutionsModule.self) { [unowned self] _ in
      InstitutionsModule(servicesContainer: self.servicesContainer, applicationFlow: self)
    }
    container.register(InstitutionDetailsModule.self) { [unowned self] (_, institutionId: InstitutionDetailsModule.IncomeData) in
      InstitutionDetailsModule(servicesContainer: self.servicesContainer, applicationFlow: self, institutionId: institutionId)
    }
    return container
  }()
  
  
  func setRootViewController(to window: UIWindow?) {
    window?.rootViewController = modulesContainer.resolve(InstitutionsModule.self)?.startupView
  }
  
  func close<M: Module>(module: M) {
    if let moduleTransitioned = module.transitioned {
      switch moduleTransitioned {
      case .modally: module.startupView.dismiss(animated: true)
      case .pushing: module.startupView.navigationController?.popViewController(animated: true)
      }
    } else {
      //first module, do nothing
    }

  }
  
  func pass<M: Module>(module: M, with result: M.OutcomeData) {
    switch module {
    case is InstitutionsModule:
      modulesContainer.resolve(InstitutionDetailsModule.self, argument: result)?.run(basedOn: module.startupView, transitioned: .modally)
    case is InstitutionDetailsModule:
      fallthrough //TODO: remove fallthrough
    default: self.close(module: module)
    }
  }
  
}


