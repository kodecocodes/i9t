//
//  TopoMapOverlayData.swift
//  Topo
//
//  Created by Derek Selander on 7/1/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation

struct HistoricMapOverlayData {
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

extension HistoricMapOverlayData {
  static func generateDefaultData()->[HistoricMapOverlayData] {
    return [
      HistoricMapOverlayData(title: "Santa Cruz", thumbnailImageTitle: "example_map", assetTitle: "SC_Map", year:1992),
      HistoricMapOverlayData(title: "San Francisco", thumbnailImageTitle: "example_map", assetTitle: "SF_Map", year:1992),
      HistoricMapOverlayData(title: "San Diego", thumbnailImageTitle: "example_map", assetTitle: "SD_Map", year:1962),
      HistoricMapOverlayData(title: "Los Angelos", thumbnailImageTitle: "example_map", assetTitle: "LA_Map", year:1942),
      HistoricMapOverlayData(title: "Mavericks", thumbnailImageTitle: "example_map", assetTitle: "Mav_Map", year:1992),
      HistoricMapOverlayData(title: "Yosemite", thumbnailImageTitle: "example_map", assetTitle: "Yos_Map", year:1985),
      HistoricMapOverlayData(title: "El Capitan", thumbnailImageTitle: "example_map", assetTitle: "Cap_Map", year:1937),
      HistoricMapOverlayData(title: "Monterey", thumbnailImageTitle: "example_map", assetTitle: "Mont_Map", year:1967),
      HistoricMapOverlayData(title: "Nappa", thumbnailImageTitle: "example_map", assetTitle: "NAP_Map", year:1944)
    ]
  }
}