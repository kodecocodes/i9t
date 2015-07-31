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


// All photographs except Bubbles are granted by the author Caroline Begbie to raywenderlich.com for commercial use.
// Bubbles is in Public Domain from http://www.publicdomainpictures.net/view-image.php?image=4277

import Foundation

struct Animal {
  let name:String
  let description:String
  let owner:String
  let address:String
  let vetIndex:Int
  let instructions:String
}

let animalData:[Animal] = [
  Animal(        name:"Bubbles",
          description:"Goldfish",
                owner:"Marshall Fry",
              address:"4 Gurnard Walk\nRockling",
             vetIndex:1,
         instructions:"Fish food"),
  Animal(        name: "Willow",
          description:"Gray pony",
                owner:"Jane Marshall",
              address:"113 Host Drive\nSurbiton",
             vetIndex:0,
         instructions:"Slab of hay\n2 carrots"),
  Animal(        name: "Sesame",
          description:"Black chicken",
                owner:"Felix Roger",
              address:"7880 Devon Road\nEllenwood",
             vetIndex:0,
         instructions:"One cup layer pellets\nOyster shell"),
  Animal(        name: "Leslie",
          description:"Lesser sulphur crested cockatoo",
                owner:"Robert Harvey",
              address:"632 Cross Street\nUnion City",
             vetIndex:1,
         instructions:"Bird feed in kitchen cupboard"),
  Animal(        name: "Kelly",
          description:"Labrador Retriever",
                owner:"Robert Harvey",
              address:"632 Cross Street\nUnion City",
             vetIndex:1,
         instructions:"Half can dog food\nDry kibbles"),
  Animal(        name: "Bertie",
          description:"Rooster",
                owner:"Laurie Greenberg",
              address:"5431 Central Ave\nSurbiton",
             vetIndex:0,
         instructions:"My leftovers\nPellets"),
  Animal(        name: "Muffin",
          description:"Fierce Maltese",
                owner:"Daisy Powell",
              address:"61 North St\nSurbiton",
             vetIndex:0,
         instructions:"Deluxe tray\nChew treat")
]

struct Vet {
  let name:String
  let address:String
  let phone:String
}

let vetData:[Vet] = [
    Vet(name: "Andrea Schulz", address: "Cutlass Way\nCastleMaine", phone: "202-555-0122"),
    Vet(name: "Bob Hammond", address: "TreeView Drive\nUnion City", phone: "202-555-0108")
]
