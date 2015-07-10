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

var checkListData = [ "Food",
                      "Medical",
                      "Equipment",
                      "To Do"]


typealias CheckListItem = (description: String, checked:Bool, notes:String)

var checkListItemData:[[CheckListItem]] =
                        [ [ ("Baked Beans",     true,   "Must be Heinz"),
                            ("Noodles",         false,  "Check gas and water available for cooking"),
                            ("Custard",         true,   "Long life"),
                            ("Dried Apricots",  true,   "For Aunt Beatrice" )  ],
                          [ ("Aspirin",         false,  " "),
                            ("Bandages",        false,  " "),
                            ("Whisky",          false,  " ") ],
                          [ ("Sharpen thing for getting stones out of horse's hooves", true, " ")],
                          [ ("Download Max Soderstrom’s Survival Guide App", true, " ")  ] ]


//MARK: - Diary Sample Data

typealias DiaryData = (date:String, diaryEntry:String)

var diaryData:[DiaryData] =
                [ ("July 2, 2016",     "Have heard rumors. Preparing."),
                  ("July 4, 2016",     "List of safe contacts arrived."),
                  ("July 5, 2016",     "Food shortages and riots"),
                  ("July 8, 2016",     "I may be underprepared. They are coming...") ]


