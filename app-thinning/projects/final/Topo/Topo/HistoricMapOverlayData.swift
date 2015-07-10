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
  let bundleTitle: String
  let year: Int
  
  init(title: String, thumbnailImageTitle: String, bundleTitle: String, year: Int) {
    self.title = title
    self.thumbnailImageTitle = thumbnailImageTitle
    self.bundleTitle = bundleTitle
    self.year = year
    
  }
}

extension HistoricMapOverlayData {
  static func generateDefaultData()->[HistoricMapOverlayData] {
    return [
      HistoricMapOverlayData(title: "Santa Cruz", thumbnailImageTitle: "example_map", bundleTitle: "SC_Map", year:1992),
      HistoricMapOverlayData(title: "San Francisco", thumbnailImageTitle: "example_map", bundleTitle: "SF_Map", year:1992),
      HistoricMapOverlayData(title: "Sunnyvale", thumbnailImageTitle: "example_map", bundleTitle: "SNVL_Map", year:1948),
      HistoricMapOverlayData(title: "San Diego", thumbnailImageTitle: "example_map", bundleTitle: "SD_Map", year:1994),
      HistoricMapOverlayData(title: "Los Angelos", thumbnailImageTitle: "example_map", bundleTitle: "LA_Map", year:1994),
      HistoricMapOverlayData(title: "Yosemite", thumbnailImageTitle: "example_map", bundleTitle: "Yos_Map", year:1987),
      HistoricMapOverlayData(title: "Monterey", thumbnailImageTitle: "example_map", bundleTitle: "Mont_Map", year:1967)
    ]
  }
}