//
//  SampleData.swift
//  Prepped
//
//  Created by Caroline Begbie on 25/06/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

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
                            ("Dried Apricots",  true,   " " )  ],
                          [ ("Aspirin",         false,  " "),
                            ("Bandages",        false,  " "),
                            ("Whisky",          false,  " ") ],
                          [ ("Sharpen thing for getting stones out of horse's hooves", true, " ")],
                          [ ("Download Max Soderstrom’s Survival Guide App", true, " ")  ] ]


//MARK: - Contact Notes Sample Data

typealias ContactsData = (imageName:String, description:String)

var contactsData:[ContactsData] =
                   [  ("CaviarRage.png",     "Has food supplies. Might share."),
                      ("CrossRage.png",      "Avoid if you can."),
                      ("ShortFuseRage.png",  "Will help, but don't push it."),
                      ("ThoughtfulRage.png", "Will come up with master plan which is too complicated to implement."),
                      ("SlasherRage.png",    "Run. Just run.") ]


//MARK: - Diary Sample Data

typealias DiaryData = (date:String, diaryEntry:String)

var diaryData:[DiaryData] =
                [ ("July 2, 2016",     "Have heard rumors. Preparing."),
                  ("July 4, 2016",     "List of safe contacts arrived."),
                  ("July 5, 2016",     "Food shortages and riots"),
                  ("July 8, 2016",     "I may be underprepared. They are coming...") ]


