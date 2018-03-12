//
//  InstitutionDetailsModule.swift
//  TestAssignment
//
//  Created by Ivan on 03.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Swinject


class InstitutionDetailsModule: Module {
  
  typealias BaseView = UIViewController

  typealias IncomeData = String
  typealias OutcomeData = Void

  var transitioned: TransitionType?
  
  private(set) var applicationFlow: ApplicationFlow?
  
  let incomeData: IncomeData
  
  let servicesContainer: Container
  
  private(set) lazy var interactorsContainer: Container = {
    let container = Container(parent: servicesContainer)
    container.register(InstitutionDetailsInteractor.self) { resolver, institutionId in
      InstitutionDetailsInteractor(holderModule: self, provider: resolver.resolve(InstitutionsProvider.self)!, institutionId: institutionId) //TODO: fix force unwrap
    }
    return container
  }()
  
  private(set) lazy var viewModelsContainer: Container = {
    let container = Container(parent: interactorsContainer)
    container.register(InstitutionDetailsViewModel.self) { (resolver, institutionId: IncomeData) in
      InstitutionDetailsViewModel(interactor: resolver.resolve(InstitutionDetailsInteractor.self, argument: institutionId)!) //TODO: fix force unwrap
    }
    return container
  }()
  
  private(set) lazy var viewsContainer: Container = {
    let container = Container(parent: viewModelsContainer)
    container.register(InstitutionDetailsViewController.self) { resolver in
      InstitutionDetailsViewController(interactor: resolver.resolve(InstitutionDetailsInteractor.self, argument: self.incomeData)!, viewModel: resolver.resolve(InstitutionDetailsViewModel.self, argument: self.incomeData)!) //TODO: fix force unwrap
    }
    return container
  }()
  
  private(set) lazy var startupView: BaseView = viewsContainer.resolve(InstitutionDetailsViewController.self)! // TODO: fix force unwrap
  
  
  init(servicesContainer: Container, applicationFlow: ApplicationFlow, institutionId: IncomeData) {
    self.servicesContainer = servicesContainer
    self.applicationFlow = applicationFlow
    self.incomeData = institutionId
  }
  
}

