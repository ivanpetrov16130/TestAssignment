//
//  Models.swift
//  TestAssignment
//
//  Created by Ivan on 04.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import Foundation


struct InstitutionAddress: Decodable {
  
  enum CodingKeys: String, CodingKey { case address, latitude, longitude, timetable = "schedule" }
  
  let address: String
  let latitude: Double
  let longitude: Double
  let timetable: String
  
}


struct Institution: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case description = "longDescription"
    case introDescription = "shortDescription"
    case addresses
    case imageUrl = "imageHref"
    case rating
  }
  
  let id: String
  let name: String
  let description: String
  let introDescription: String
  let addresses: [InstitutionAddress]
  let imageUrl: URL
  let rating: Double
  
}
