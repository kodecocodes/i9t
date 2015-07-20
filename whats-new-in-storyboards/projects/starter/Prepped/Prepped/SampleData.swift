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

//MARK: - Check List Sample Data

struct CheckList {
  let title: String
  var items = [CheckListItem]()
}

struct CheckListItem {
  let name: String
  var checked: Bool
  let notes: String
  
  init(_ name: String, checked: Bool = false, notes: String = " ") {
    self.name = name
    self.checked = checked
    self.notes = notes
  }
}

var checkLists = [ CheckList(title: "Food", items: [ CheckListItem("Baked Beans", checked: true, notes: "Must be Heinz"),
                                                     CheckListItem("Noodles", checked: false, notes: "Check gas and water available for cooking"),
                                                     CheckListItem("Custard", checked: true, notes: "Long life"),
                                                     CheckListItem("Dried Apricots", checked: true, notes: "For Aunt Beatrice") ]),
  
                   CheckList(title: "Medical", items: [ CheckListItem("Aspirin"),
                                                        CheckListItem("Bandages"),
                                                        CheckListItem("Whisky") ]),
  
                   CheckList(title: "Equipment", items: [ CheckListItem("Sharpened thing for getting stones out of horse's hooves") ]),
  
                   CheckList(title: "To Do", items: [ CheckListItem("Download Max Soderstrom’s Survival Guide App") ])
]

//MARK: - Diary Sample Data

struct DiaryEntry {
  let date: String
  let text: String
}

var diaryEntries = [ DiaryEntry(date: "July 2, 2016", text: "Have heard rumors. Preparing."),
                     DiaryEntry(date: "July 4, 2016", text: "List of safe contacts arrived."),
                     DiaryEntry(date: "July 5, 2016", text: "Food shortages and riots"),
                     DiaryEntry(date: "July 8, 2016", text: "I may be underprepared. They are coming...") ]

