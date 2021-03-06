//
//  InstitutionsModule.swift
//  TestAssignment
//
//  Created by Ivan on 03.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Swinject


class InstitutionsModule: Module {
    
  typealias BaseView = UINavigationController

  typealias IncomeData = Void
  typealias OutcomeData = String

  var transitioned: TransitionType?
  
  private(set) var applicationFlow: ApplicationFlow?
  
  let incomeData: IncomeData = ()
  
  let servicesContainer: Container
  
  private(set) lazy var interactorsContainer: Container = {
    let container = Container(parent: servicesContainer)
    container.register(InstitutionsInteractor.self) { resolver in //TODO: find da way to actually use IoC here and everywhere
      InstitutionsInteractor(holderModule: self, provider: resolver.resolve(InstitutionsProvider.self)!) //TODO: fix force unwrap
    }
    return container
  }()
  
  private(set) lazy var viewModelsContainer: Container = {
    let container = Container(parent: interactorsContainer)
    container.register(InstitutionsViewModel.self) { resolver in
      InstitutionsViewModel(interactor: resolver.resolve(InstitutionsInteractor.self)!) //TODO: fix force unwrap
    }
    return container
  }()
  
  private(set) lazy var viewsContainer: Container = {
    let container = Container(parent: viewModelsContainer)
    container.register(InstitutionsViewController.self) { resolver in
      InstitutionsViewController(interactor: resolver.resolve(InstitutionsInteractor.self)!, viewModel: resolver.resolve(InstitutionsViewModel.self)!) //TODO: fix force unwrap
    }
    return container
  }()
  
  lazy var startupView: UINavigationController = BaseView.init(rootViewController: viewsContainer.resolve(InstitutionsViewController.self)!) // TODO: fix force unwrap
  
  
  required init(servicesContainer: Container, applicationFlow: ApplicationFlow) {
    self.servicesContainer = servicesContainer
    self.applicationFlow = applicationFlow
  }
  
}
