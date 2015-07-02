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
  let year: Int = 1998
  
  init(title: String, thumbnailImageTitle: String, assetTitle: String) {
    self.title = title
    self.thumbnailImageTitle = thumbnailImageTitle
    self.assetTitle = assetTitle
    
  }
}


extension TopoMapOverlayData {
  static func generateDefaultData()->[TopoMapOverlayData] {
    return [TopoMapOverlayData(title: "Santa Cruz", thumbnailImageTitle: "example_map", assetTitle: "SC_Map"),
    TopoMapOverlayData(title: "San Francisco", thumbnailImageTitle: "example_map", assetTitle: "SF_Map"),
    TopoMapOverlayData(title: "San Diego", thumbnailImageTitle: "example_map", assetTitle: "SD_Map"),
    TopoMapOverlayData(title: "Los Angelos", thumbnailImageTitle: "example_map", assetTitle: "LA_Map"),
    TopoMapOverlayData(title: "Mavericks", thumbnailImageTitle: "example_map", assetTitle: "MAV_Map"), TopoMapOverlayData(title: "Yosemite", thumbnailImageTitle: "example_map", assetTitle: "YOS_Map"), TopoMapOverlayData(title: "El Capitan", thumbnailImageTitle: "example_map", assetTitle: "CAP_Map"), TopoMapOverlayData(title: "Monterey", thumbnailImageTitle: "example_map", assetTitle: "MONT_Map"), TopoMapOverlayData(title: "Nappa", thumbnailImageTitle: "example_map", assetTitle: "NAP_Map")]
//    return []
  }
}