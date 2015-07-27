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


// All photographs are granted by the author Caroline Begbie to raywenderlich.com for commercial use.

import Foundation

typealias Animal = (name: String, description: String, owner:String, address: String, vetIndex: Int, instructions:String)
var animalData:[Animal] = [
  ("Willow", "Gray pony",     "Jane Marshall", "113 Host Drive\nSurbiton", 0, "Slab of hay\n2 carrots"),
  ("Sesame",  "Black chicken", "Felix Roger", "7880 Devon Road\nEllenwood", 0,   "One cup layer pellets\nOyster shell"),
  ("Leslie", "Lesser sulphur crested cockatoo", "Robert Harvey", "632 Cross Street\nUnion City", 1, "Bird feed in kitchen cupboard"),
  ("Kelly",  "Labrador Retriever", "Robert Harvey", "632 Cross Street\nUnion City", 1,   "Half can dog food\nDry kibbles"),
  ("Bertie", "Rooster", "Laurie Greenberg", "5431 Central Ave\nSurbiton", 0, "My leftovers\nPellets"),
  ("Muffin", "Fierce Maltese", "Daisy Powell", "61 North St\nSurbiton", 0,   "Deluxe tray\nChew treat")
]

typealias Vet = (name: String, address: String, phone: String)

var vetData:[Vet] = [
  ("Andrea Schulz",   "Cutlass Way\nCastleMaine",   "202-555-0122"),
  ("Bob Hammond",     "TreeView Drive\nUnion City", "202-555-0108")
]
