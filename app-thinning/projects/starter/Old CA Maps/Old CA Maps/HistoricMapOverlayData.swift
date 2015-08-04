/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

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
      HistoricMapOverlayData(title: "San Diego", thumbnailImageTitle: "San Diego", bundleTitle: "SD_Map", year:1994),
      HistoricMapOverlayData(title: "Santa Cruz", thumbnailImageTitle: "Santa Cruz", bundleTitle: "SC_Map", year:1992),
      HistoricMapOverlayData(title: "Sunnyvale", thumbnailImageTitle: "Sunnyvale", bundleTitle: "SNVL_Map", year:1948),
      HistoricMapOverlayData(title: "San Francisco", thumbnailImageTitle: "San Francisco", bundleTitle: "SF_Map", year:1992),
      HistoricMapOverlayData(title: "Los Angeles", thumbnailImageTitle: "Los Angeles", bundleTitle: "LA_Map", year:1994),
    ]
  }
  
  static func generateAllBundleTitles()->Set<String> {
    var titles = Set<String>()
    for mapOverlayData in generateDefaultData() {
      titles.insert(mapOverlayData.bundleTitle)
    }
    return titles
  }
}