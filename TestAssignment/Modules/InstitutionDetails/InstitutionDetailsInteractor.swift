//
//  InstitutionDetailsViewModel.swift
//  TestAssignment
//
//  Created by Ivan on 01.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MapKit

class InstitutionDetailsInteractor: BasicInteractor {

  typealias View = InstitutionDetailsViewController
  
  enum State {
    case initial
    case loadingInstitutionDetails
    case loaded(institutionDetails: Institution)
    case failedLoadingInstitutionDetails(error: Error)
    case noInstitutionDetails
  }
  
  let viewStatesReactionQueue: DispatchQueue = InstitutionDetailsInteractor.newViewStatesReactionQueue
  private(set) weak var holderModule: InstitutionDetailsModule?
  private let provider: InstitutionsProvider
  private let disposeBag = DisposeBag()
  
  let state: ObservableState = BehaviorRelay(value: .initial)
  let institutionId: InstitutionDetailsModule.IncomeData
  
  
  required init(holderModule: InstitutionDetailsModule, provider: InstitutionsProvider, institutionId: InstitutionDetailsModule.IncomeData) {
    self.holderModule = holderModule
    self.provider = provider
    self.institutionId = institutionId
  }
  
  func state(for viewState: View.State) {
    switch viewState {
    case .viewDidLoad:
      state.accept(.loadingInstitutionDetails)
      provider.rx.request(.institutionDetails(institutionId: institutionId))
        .map(Institution.self)
        .subscribe(onSuccess: { [unowned self] institution in
          self.state.accept(.loaded(institutionDetails: institution))
        }) { [unowned self] (error) in
          self.state.accept(.failedLoadingInstitutionDetails(error: error))
        }
        .disposed(by: disposeBag)
    case .viewDidClose:
      holderModule?.finish(outcome: .finished(result: ()))
    case .mapDidOpenForAddress(at: let index):
      if case let .loaded(institutionDetails: institution) = self.state.value,
        institution.addresses.endIndex > index, !(index < institution.addresses.startIndex) {
        let address = institution.addresses[index]
        let mapCoordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        let mappedAddress = MKMapItem(placemark: MKPlacemark(coordinate: mapCoordinate, addressDictionary:nil))
        mappedAddress.name = address.address
        mappedAddress.openInMaps() //TODO: move this login into appropriate manager
      }
    }
  }

}
