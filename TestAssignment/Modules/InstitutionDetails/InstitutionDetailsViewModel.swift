//
//  InstitutionDetailsViewModel.swift
//  TestAssignment
//
//  Created by iOS Developer 1 on 06.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class InstitutionDetailsViewModel: BasicViewModel {
  
  typealias View = InstitutionDetailsViewController
  
  let interactor: View.Interactor
  let disposeBag = DisposeBag()
  
  let isActivityIndicatorActive: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  let errorDataSource: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
  let institutionImageDataSource: BehaviorRelay<UIImage> = BehaviorRelay(value: #imageLiteral(resourceName: "placeholderImage"))
  let institutionNameDataSource: BehaviorRelay<String> = BehaviorRelay(value: "")
  let institutionRatingDataSource: BehaviorRelay<String> = BehaviorRelay(value: "")
  let institutionDescriptionDataSource: BehaviorRelay<String> = BehaviorRelay(value: "")
  let institutionAddressesDataSource: BehaviorRelay<[InstitutionAddress]> = BehaviorRelay(value: [])

  
  required init(interactor: View.Interactor) {
    self.interactor = interactor
    
    interactor.state.subscribe(onNext: { [unowned self] (state) in
      switch state {
      case .loadingInstitutionDetails:
        self.isActivityIndicatorActive.accept(true)
      case .loaded(institutionDetails: let institution):
        self.isActivityIndicatorActive.accept(false)
        ImageDownloader.default.downloadImage(with: institution.imageUrl) { image, _, _, _ in
          guard let image = image else { return }
          self.institutionImageDataSource.accept(image)
        }
        self.institutionNameDataSource.accept(institution.name)
        self.institutionRatingDataSource.accept("\(institution.rating)")
        self.institutionDescriptionDataSource.accept(institution.description)
        self.institutionAddressesDataSource.accept(institution.addresses)
      case .failedLoadingInstitutionDetails(error: let error):
        self.isActivityIndicatorActive.accept(false)
        self.errorDataSource.accept(error)
      default:
        self.errorDataSource.accept(nil)
      }
    })
      .disposed(by: disposeBag)
  }
  
}
