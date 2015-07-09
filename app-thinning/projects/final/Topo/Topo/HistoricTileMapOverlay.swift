//
//  HistoricMapOverlay.swift
//  Topo
//
//  Created by Derek Selander on 6/28/15.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
import MapKit

let kTileSize = 256.0


class HistoricTileMapOverlay: MKTileOverlay {
  
  
  override var boundingMapRect: MKMapRect { get { return self.private_boundingRect }}
  override var coordinate: CLLocationCoordinate2D { get { return self.getCoordinate() }}
  override var title: String? { get {return "title"}}
  override var subtitle: String? { get {return "test subtitle"}}
  
//  var region: MKCoordinateRegion {  get{ return self.getRegion() }}
  
  private var tileSet = Set<String>()
  private var private_boundingRect: MKMapRect!
//  private var private_URLTemplate: String?
  private var baseDirectoryPath: String!
  
  var image : UIImage
  var auxillaryInfo : [String : AnyObject]!
  
  init(titleDirectory: String) {
    self.image = UIImage() // change me
    self.auxillaryInfo = [:] // change me
    
    super.init(URLTemplate: titleDirectory)
    self.parseShit(titleDirectory)
    self.geometryFlipped = true
  }
  
  override func URLForTilePath(path: MKTileOverlayPath) -> NSURL {
    let url =  super.URLForTilePath(path)
    return url
  }
  
  override func loadTileAtPath(path: MKTileOverlayPath, result: (NSData?, NSError?) -> Void) {
    super.loadTileAtPath(path, result: result)
  }
  
  private func getCoordinate()->CLLocationCoordinate2D {
    return MKCoordinateForMapPoint(MKMapPoint(x: MKMapRectGetMidX(self.boundingMapRect), y: MKMapRectGetMidY(self.boundingMapRect)))
  }
  
  private func parseShit(tileDirectory : String) {
    self.baseDirectoryPath = tileDirectory
    let fileManager = NSFileManager.defaultManager()
    
    let tilesPath = tileDirectory.stringByAppendingPathComponent("Tiles")
    
    let fileEnumerator = fileManager.enumeratorAtPath(tilesPath)
    
    var pathSet = Set<String>()
    var minZ = Int.max
    
    while let path = fileEnumerator?.nextObject() {
      if path.pathExtension.caseInsensitiveCompare("png") == .OrderedSame {
        var components = path.stringByDeletingPathExtension.pathComponents as [String]
        if components.count == 3 {
          let z = Int(components[0])!
          let x = Int(components[1])!
          let y = Int(components[2])!
          
          let tileKey = "\(z)/\(x)/\(y)"
          pathSet.insert(tileKey)
          
          if z < minZ {
            minZ = z
          }
        }
      }
    }
    
    assert(pathSet.count > 0)
    
    var minX = Int.max
    var minY = Int.max
    var maxX = 0
    var maxY = 0
    
    for tileKey in pathSet {
      let components = tileKey.pathComponents
      let z = Int(components[0])
      let x = Int(components[1])
      let y = Int(components[2])
      
      if z == minZ {
        minX = min(minX, x!)
        minY = min(minY, y!)
        maxX = max(maxX, x!)
        maxY = max(maxY, y!)
      }
    }
    
    let tilesAtZ = Int(pow(2.0, Double(minZ)))
    let sizeAtZ = Double(tilesAtZ) * kTileSize
    let zoomScaleAtMinZ = sizeAtZ / MKMapSizeWorld.width
    
    let flippedMinY = abs(minY + 1 - tilesAtZ)
    let flippedMaxY = abs(maxY + 1 - tilesAtZ)
    
    let x0 = (Double(minX) * kTileSize) / zoomScaleAtMinZ
    let x1 = ((Double(maxX) + 1) * kTileSize) / zoomScaleAtMinZ
    let y0 = (Double(flippedMaxY) * kTileSize) / zoomScaleAtMinZ
    let y1 = ((Double(flippedMinY) + 1) * kTileSize) / zoomScaleAtMinZ
    
    self.private_boundingRect = MKMapRect(origin: MKMapPoint(x: x0, y: y0), size: MKMapSize(width: x1-x0, height: y1-y0))
    self.tileSet = pathSet
    
  }
  
  private func zoomScaleToZoomLevel(scale: MKZoomScale)->Int {
    let numTilesAt1_0 = MKMapSizeWorld.width / kTileSize
    let zoomLevelAt1_0 = log2(numTilesAt1_0)
    let zoomLevel = max(0, zoomLevelAt1_0 + Double(floor(log2(scale) + 0.5)))
    return Int(zoomLevel)
  }
  
  func tilesInMapRect(rect: MKMapRect, scale: MKZoomScale)->[ImageTile] {
    
    var tiles = [ImageTile]()
    let z = self.zoomScaleToZoomLevel(scale)
    let tilesAtZ = Int(pow(2.0, Double(z)))
    
    let minX = Int(floor((MKMapRectGetMinX(rect) * Double(scale)) / kTileSize))
    let maxX = Int(floor((MKMapRectGetMaxX(rect) * Double(scale)) / kTileSize))
    let minY = Int(floor((MKMapRectGetMinY(rect) * Double(scale)) / kTileSize))
    let maxY = Int(floor((MKMapRectGetMaxY(rect) * Double(scale)) / kTileSize))
    
    for var x = minX; x <= maxX; x++  {
      for var y = minY; y <= maxY; y++ {
        let flippedY = abs(y + 1 - tilesAtZ)
        let tileKey = "\(z)/\(x)/\(flippedY)"
        
        if tileSet.contains(tileKey) {
          let point = MKMapPoint(x: (Double(x) * kTileSize) / Double(scale), y: (Double(y) * kTileSize) / Double(scale))
          let size = MKMapSize(width: kTileSize / Double(scale), height: kTileSize / Double(scale))
          let frame = MKMapRect(origin: point, size: size)
          
          let fullPath = "\(self.baseDirectoryPath)/Tiles/\(tileKey).png"
          let tile = ImageTile(imagePath: fullPath, mapRect: frame)
          tiles.append(tile)
        }
      }
    }
    
    return tiles
  }
}
