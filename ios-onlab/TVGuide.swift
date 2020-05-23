//
//  TVGuide.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 05. 08..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import Foundation


class TVGuide: NSObject, XMLParserDelegate {
    
    var programs = [TVProgramme]()
    var title: String?
    var startTime: String?
    var stopTime: String?
    var channel: String?
    var desc: String?
    var elementName = String()
    
    func getCurrentTitles() -> [String] {
        var titles = [String]()
        for program in programs {
            var alreadyInArray = false
            for title in titles {
                if title.trimmingCharacters(in: .whitespacesAndNewlines) == program.title.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("\(title) == \(program.title)")
                    alreadyInArray = true
                    break
                }
            }
            if alreadyInArray {
                continue
            }
            
            let currentDateTime = Date()
            let userCalendar = Calendar.current;
            let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day,
                .hour,
                .minute,
                .second
            ]
            let currentDateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
            let programStartDateTimeComponents = userCalendar.dateComponents(requestedComponents, from: program.startTime)
            if(currentDateTimeComponents.year == programStartDateTimeComponents.year &&
               currentDateTimeComponents.month == programStartDateTimeComponents.month &&
               currentDateTimeComponents.day == programStartDateTimeComponents.day) {
                if(programStartDateTimeComponents.hour! - currentDateTimeComponents.hour! < 1 && programStartDateTimeComponents.hour! - currentDateTimeComponents.hour! > -1) {
                    titles.append(program.title)
                }
            }

        }
        print("\(titles.count) titles found on tv now")
        return titles
    }
    
    
    func fillTVGuide() {
        if let path = Bundle.main.url(forResource: "guide", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            } else {
                print("Could not create parser for the xml file")
            }
        } else {
            print("xml file could not be found")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "programme" {
            startTime = String()
            stopTime = String()
            channel = String()
            
            startTime = attributeDict["start"]
            stopTime = attributeDict["stop"]
            channel = attributeDict["channel"]
        }
        
        if elementName == "title" {
            title = String()
        }
        
        if elementName == "desc" {
            desc = String()
        }

        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "programme" {
            if channel != nil, title != nil {
                let tvProgram = TVProgramme(startTime: startTime ?? "N/A", finishTime: stopTime ?? "N/A", channel: channel!, title: title!, desc: desc ?? "N/A")
                programs.append(tvProgram)
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                title! += data
            } else if self.elementName == "desc" {
                desc! += data
            }
        }
    }
    
}

struct TVProgramme {
    var startTime: Date
    var finishTime: Date
    var channel: String
    var title: String
    var description: String
    
    init(startTime: String, finishTime: String, channel: String, title: String, desc: String) {
        self.title = title
        self.channel = channel
        self.description = desc
        
        // date format: "20200508023000 +0200"
        let startString = startTime.split(separator: " ")[0]
        let stopString = finishTime.split(separator: " ")[0]
        
        var startIndex = startString.index(startString.startIndex, offsetBy: 0)
        var endIndex = startString.index(startString.startIndex, offsetBy: 4)
        let startYear = Int(startString[startIndex..<endIndex])
        let stopYear = Int(stopString[startIndex..<endIndex])
        
        startIndex = endIndex
        endIndex = startString.index(startIndex, offsetBy: 2)
        let startMonth = Int(startString[startIndex..<endIndex])
        let stopMonth = Int(stopString[startIndex..<endIndex])
        
        startIndex = endIndex
        endIndex = startString.index(startIndex, offsetBy: 2)
        let startDay = Int(startString[startIndex..<endIndex])
        let stopDay = Int(stopString[startIndex..<endIndex])
        
        startIndex = endIndex
        endIndex = startString.index(startIndex, offsetBy: 2)
        let startHour = Int(startString[startIndex..<endIndex])
        let stopHour = Int(stopString[startIndex..<endIndex])

        startIndex = endIndex
        endIndex = startString.index(startIndex, offsetBy: 2)
        let startMinute = Int(startString[startIndex..<endIndex])
        let stopMinute = Int(stopString[startIndex..<endIndex])
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "CET")

        dateComponents.year = startYear
        dateComponents.month = startMonth
        dateComponents.day = startDay
        dateComponents.hour = startHour
        dateComponents.minute = startMinute
        
        let userCalendar = Calendar.current // user calendar
        self.startTime = userCalendar.date(from: dateComponents)!
        
        dateComponents.year = stopYear
        dateComponents.month = stopMonth
        dateComponents.day = stopDay
        dateComponents.hour = stopHour
        dateComponents.minute = stopMinute
        
        self.finishTime = userCalendar.date(from: dateComponents)!

        print("New program: \(self.title) on \(self.channel) from \(self.startTime) until \(self.finishTime)")
    }
}
