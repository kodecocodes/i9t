//
//  TopoMapOverlayData.swift
//  Topo
//
//  Created by Derek Selander on 7/1/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation

struct TopoMapOverlayData {
  let title: String
  let thumbnailImageTitle: String
  let assetTitle: String
  let year: Int
  
  
  init(title: String, thumbnailImageTitle: String, assetTitle: String, year: Int) {
    self.title = title
    self.thumbnailImageTitle = thumbnailImageTitle
    self.assetTitle = assetTitle
    self.year = year
    
  }
}

extension TopoMapOverlayData {
  static func generateDefaultData()->[TopoMapOverlayData] {
    return [
      TopoMapOverlayData(title: "Santa Cruz", thumbnailImageTitle: "example_map", assetTitle: "SC_Map", year:1992),
      TopoMapOverlayData(title: "San Francisco", thumbnailImageTitle: "example_map", assetTitle: "SF_Map", year:1992),
      TopoMapOverlayData(title: "San Diego", thumbnailImageTitle: "example_map", assetTitle: "SD_Map", year:1962),
      TopoMapOverlayData(title: "Los Angelos", thumbnailImageTitle: "example_map", assetTitle: "LA_Map", year:1942),
      TopoMapOverlayData(title: "Mavericks", thumbnailImageTitle: "example_map", assetTitle: "Mav_Map", year:1992),
      TopoMapOverlayData(title: "Yosemite", thumbnailImageTitle: "example_map", assetTitle: "Yos_Map", year:1985),
      TopoMapOverlayData(title: "El Capitan", thumbnailImageTitle: "example_map", assetTitle: "Cap_Map", year:1937),
      TopoMapOverlayData(title: "Monterey", thumbnailImageTitle: "example_map", assetTitle: "MoNt_Map", year:1967),
      TopoMapOverlayData(title: "Nappa", thumbnailImageTitle: "example_map", assetTitle: "NAP_Map", year:1944)
    ]
  }
}