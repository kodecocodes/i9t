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
  
  
  override var boundingMapRect: MKMapRect { get { return self.p__boundingRect }}
  override var coordinate: CLLocationCoordinate2D { get { return self.getCoordinate() }}
  override var title: String? { get {return "title"}}
  override var subtitle: String? { get {return "test subtitle"}}
  override var URLTemplate: String? { get { return ""} }
  
  
  var region: MKCoordinateRegion {          get{ return self.getRegion() }}
  
  private var tileSet = Set<String>()
  private var p__boundingRect: MKMapRect!
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
  
  

  
  private func getCoordinate()->CLLocationCoordinate2D {
    let centerDict = self.auxillaryInfo["Center"] as! [String : Double]
    return CLLocationCoordinate2D(latitude: centerDict["lattitude"]!, longitude: centerDict["longitude"]!)
  }
  
  override func URLForTilePath(path: MKTileOverlayPath) -> NSURL {
    let url =  super.URLForTilePath(path)
    return url
  }
  
  override func loadTileAtPath(path: MKTileOverlayPath, result: (NSData?, NSError?) -> Void) {
    super.loadTileAtPath(path, result: result)
  }
  
  private func getMapRect()-> MKMapRect {
    
    let topLeftDict = self.auxillaryInfo["TopLeft"] as! [String : Double]
    let topLeftCoordinate = CLLocationCoordinate2D(latitude: topLeftDict["lattitude"]!, longitude: topLeftDict["longitude"]!)
    
    let topRightDict = self.auxillaryInfo["TopRight"] as! [String : Double]
    let topRightCoordinate = CLLocationCoordinate2D(latitude: topRightDict["lattitude"]!, longitude: topRightDict["longitude"]!)
    
    
    let bottomLeftDict = self.auxillaryInfo["BottomLeft"] as! [String : Double]
    let bottomLeftCoordinate = CLLocationCoordinate2D(latitude: bottomLeftDict["lattitude"]!, longitude: bottomLeftDict["longitude"]!)
    
    let topLeftPoint = MKMapPointForCoordinate(topLeftCoordinate)
    let topRightPoint = MKMapPointForCoordinate(topRightCoordinate)
    let bottomLeftPoint = MKMapPointForCoordinate(bottomLeftCoordinate)
    
    return MKMapRectMake(topLeftPoint.x, topLeftPoint.y, fabs(topLeftPoint.x - topRightPoint.x), fabs(topLeftPoint.y - bottomLeftPoint.y))
  }
  
  private func getRegion()->MKCoordinateRegion {
    let coordinateDict = self.auxillaryInfo["MapRegion"] as! [String: Double]
    let lat = coordinateDict["lat"]
    let lon = coordinateDict["lon"]
    let sLat = coordinateDict["spanLat"]
    let sLon = coordinateDict["spanLon"]
    return  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat!, longitude: lon!), span: MKCoordinateSpan(latitudeDelta: sLat!, longitudeDelta: sLon!))
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
    
    self.p__boundingRect = MKMapRect(origin: MKMapPoint(x: x0, y: y0), size: MKMapSize(width: x1-x0, height: y1-y0))
    self.tileSet = pathSet
    
  }
  
  func zoomScaleToZoomLevel(scale: MKZoomScale)->Int {
    let numTilesAt1_0 = MKMapSizeWorld.width / kTileSize
    let zoomLevelAt1_0 = log2(numTilesAt1_0)
    let zoomLevel = max(0, zoomLevelAt1_0 + Double(floor(log2(scale) + 0.5)))
    return Int(zoomLevel)
  }
  
  
  
  func tilesInMapRect(rect: MKMapRect, scale: MKZoomScale)->[ImageTile]? {
    
    let z = self.zoomScaleToZoomLevel(scale)
    let tilesAtZ = pow(2.0, Double(z))
    
    let minX = floor((MKMapRectGetMinX(rect) * Double(scale)) / kTileSize)
    let maxX = floor((MKMapRectGetMaxX(rect) * Double(scale)) / kTileSize)
    let minY = floor((MKMapRectGetMinY(rect) * Double(scale)) / kTileSize)
    let maxY = floor((MKMapRectGetMaxY(rect) * Double(scale)) / kTileSize)
    
    var tiles : [ImageTile]? = nil
    for var x = minX; x <= maxX; x++  {
      for var y = minY; y <= maxY; y++ {
        let flippedY = abs(y + 1 - tilesAtZ)
        let tileKey = "\(z)/\(x)/\(flippedY)"
        
        if tileSet.contains(tileKey) {
          if tiles == nil {
            tiles = [ImageTile]()
          }
          
          let point = MKMapPoint(x: (x * kTileSize) / Double(scale), y: (y * kTileSize) / Double(scale))
          let size = MKMapSize(width: kTileSize / Double(scale), height: kTileSize / Double(scale))
          let frame = MKMapRect(origin: point, size: size)
          
          let fullPath = "\(self.baseDirectoryPath)/\(tileKey).png"
          let tile = ImageTile(imagePath: fullPath, mapRect: frame)
          tiles?.append(tile)
        }
      }
    }
    
    return tiles
  }
}
