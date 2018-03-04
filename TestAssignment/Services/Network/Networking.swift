//
//  NetworkService.swift
//  TestAssignment
//
//  Created by Ivan on 03.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation
import Moya


typealias InstitutionsProvider = MoyaProvider<InstitutionsApi>


enum InstitutionsApi {
  case institutions
  case institutionDetails(institutionId: String)
}

extension InstitutionsApi: TargetType {
  
//  var environmentBaseUrl: String {
//
//  }
  
  var baseURL: URL { return URL(string: "https://project-8716260381830912889.firebaseio.com")! }
  
  var path: String {
    switch self {
    case .institutions: return "/offices.json"
    case .institutionDetails(institutionId: let institutionId): return "/offices/\(institutionId).json"
    }
  }
  
  var method: Moya.Method { return .get }
  
  var sampleData: Data { return Data() }
  
  var task: Task { return .requestPlain }
  
  var headers: [String : String]? { return nil }
  
}

//protocol NetworkService {
//  var institutionsProvider:
//}
//
//class InstitutionsNetworkService: NetworkService {
//
//}

