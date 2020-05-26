//
//  TVGuide.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 05. 08..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import Foundation

// TV műsor letöltése internetről, xml parse-olása. Nagyban ennyi a feladata
class TVGuide: NSObject, XMLParserDelegate {
    
    // Userdefaults perzisztens tárhely hivatkozás
    let defaults = UserDefaults.standard
    
    // az összes TV csatorna amiről van információ
    var allChannels = [Channel]()
    
    // azok a csatornák, amiket a felhasználó kiválasztott, hogy szeretne innen műsorinformációkat kapni
    var userSelectedChannels = [Channel]()
    
    // egy műsor xml-kódbeli és valós neveit tartalmazó dictionary
    var channelDictionary = [String : String]()
    
    // itt tárolódik minden műsorinformáció, amit a letöltött xml-ről tölt, majd formáz
    var programs = [TVProgramme]()
    
    /* Az xml file parse-olásához felhasznált változók. Csak a parse-olás közben kellenek, lényegi infót nem tartalmaznak utána*/
    var channelName: String?
    var channelID: String?
    var title: String?
    var startTime: String?
    var stopTime: String?
    var channel: String?
    var desc: String?
    var elementName = String()
    /* ------------------------------------------*/
    
    // Kódból beállítja azokat a csatornákat amiket a feéhaszáló szeretne látni. Időleges megoldás, a véglegesben a user a SettingsView-ben fogja tudni ezeket kiválasztani
    func setUserSelectedChannels() {
        let preferredChannels = ["AXN CE", "Cinemax", "Film Mania", "Film+", "Mozi+", "RTL Klub", "RTL2", "TV2", "Cool", "Film Mania", "Film Now", "Filmbox Plus", "Filmbox Premium", "Filmbox Family", "Filmbox Basic", "FilmCafe", "HBO HU", "HBO2", "HBO3", "Nicktoons", "Paramount Channel", "Viasat3", "Viasat6"]
        for channel in allChannels {
            if preferredChannels.contains(channel.name) {
                userSelectedChannels.append(channel)
            }
        }
    }
    
    // Adott minden műsorinformáció az xml-ből, és azok a csatornák, amikről szeretne infót kapni a felhasználó. Ez a függvény visszatér a releváns adókon éppen adásban lévő műsorokkal(TVProgramme példányok, nem Movie-k)
    func getCurrentTitles() -> [TVProgramme] {
        setUserSelectedChannels()
        var programsOnTV = [TVProgramme]() // üres még a tömb
        for program in programs {
            if !userSelectedChannels.contains(where: {$0.name == program.channel}) {
                // ha a műsor nem releváns adón fut, skip
                continue
            }
            
            let currentDateTime = Date()
            // a műsort eltároljuk a függvényvisszatérési tömbbe, ha épp most van adásban (azt itt már tudjuk, hogy releváns csatornán van)
            if currentDateTime > program.startTime && currentDateTime < program.finishTime {
                print("\(program.title) is now on tv on channel: \(program.channel)")
                programsOnTV.append(program)
            }
        }
        print("\(programsOnTV.count) titles found on tv now")
        return programsOnTV
    }
    
    // kapott url-ről letölti a műsorújság xml-t (igazából bármi letöltésére alkalmas), beteszi a kapott könyvtárba (Application Support könyvtár, user által nem olvasható, nem írható), és elindítja a letöltött xml parseolását.
    func download(from url: URL, to directory: URL, with list: MovieList) {
        print("Downloading the xml.")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: directory)
                    let lastRefresh = Date()
                    // Perzisztensen eltárolja az utolsó frissítés idejét
                    self.defaults.set(lastRefresh, forKey: "lastXmlRefresh")
                    self.startParsing(to: list)
                }
                catch (let writeError) {
                    print("Error writing the file: \(writeError)")
                }
            }
            else {
                print("Failed")
            }
        }
        task.resume()
    }
    
    // Kiolvassa az xml filet, és feldolgozza
    func startParsing(to list: MovieList) {
        let appSupportDir = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let source = appSupportDir.appendingPathComponent("guide").appendingPathExtension("xml")
        
        let parser = XMLParser(contentsOf: source)
        parser?.delegate = self
        if (parser?.parse())! {
            list.fillUpList()
            DispatchQueue.main.async {
                list.availableChannels = self.allChannels // UI módosító, a fő szálon kell fusson
            }
        }
    }
    
    // ha már van letöltött, egy napnál frissebb műsorújság, akkor elindítja a parse-olást, egyéb esetben előbb letölti az xml műsorújágot
    func fillTVGuide(requested_by list: MovieList) {
        
        // Application Support könyvtárba menti, mert ez nem olvasható/írható a felhasználó számára
        let appSupportDir = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination = appSupportDir.appendingPathComponent("guide").appendingPathExtension("xml")
        let lastRefresh = defaults.object(forKey: "lastXmlRefresh") as? Date
        
        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: destination.path) && lastRefresh != nil && (Date().timeIntervalSince(lastRefresh!) < 86400/*1day in sec*/)) {
            startParsing(to: list)
        } else {
            let original = "https://guidex.ml/all/guide.xml"
            if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                if let url = URL(string: encoded) {
                    download(from: url, to: destination, with: list)
                }
            }
        }
}
    
    // Az xml parser xml attribútumba kezdett
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
        
        if elementName == "display-name" {
            channelName = String()
        }
        
        if elementName == "channel" {
            channelID = attributeDict["id"]
        }

        self.elementName = elementName
    }
    
    // az xml parser befejezett egy attribútumot
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "programme" {
            if channel != nil, title != nil {
                let tvProgram = TVProgramme(startTime: startTime ?? "N/A", finishTime: stopTime ?? "N/A", channel: channelDictionary[channel!]!, title: title!, desc: desc ?? "N/A")
                programs.append(tvProgram)
            }
        } else if elementName == "display-name" {
            let newChannel = Channel(name: channelName!)
            allChannels.append(newChannel)
            channelDictionary[channelID!] = channelName!
        }
    }

    // az xml parser egy attribútum olvasásának kellős közepében van
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                title! += data
            } else if self.elementName == "desc" {
                desc! += data
            } else if self.elementName == "display-name" {
                channelName! += data
            }
        }
    }
    
}

// Az xml-ben kapott műsorújság csatornáinak ad id-t (az id a SettingView kijelölésnél lesz fontos, mert ott UUID-t kell haszálnuk a megkülönbözetésre)
struct Channel: Identifiable, Equatable {
    var name: String
    var id: UUID
    init(name: String) {
        self.name = name
        self.id = UUID()
    }
}

// TV műsor egy eleméről tárol infókat (cím, csatorna, kezdési- és befejezési idő)
struct TVProgramme {
    var startTime: Date
    var finishTime: Date
    var channel: String
    var title: String
    var description: String
    var imdbId = ""
    
    init(startTime: String, finishTime: String, channel: String, title: String, desc: String) {
        self.title = title
        let dotIndex = channel.firstIndex(of: ".")
        let range = channel.startIndex ..< (dotIndex ?? channel.endIndex)
        self.channel = String(channel[range])
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

        //print("New program: \(self.title) on \(self.channel) from \(self.startTime) until \(self.finishTime)")
    }
}
