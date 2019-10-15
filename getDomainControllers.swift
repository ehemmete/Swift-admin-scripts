//
//  getDomainControllers.swift
//  
//
//  Created by Eric.Hemmeter on 10/15/19.
//

import Foundation

let domainName = "domain.com"

func getDomainControllerAddress() -> String? {
    let command = Process()
    let output = Pipe()
    
    command.launchPath = "/usr/bin/host"
    command.arguments = ["-t", "SRV", "_ldap._tcp.\(domainName)"]
    command.standardOutput = output
    command.launch()
    command.waitUntilExit()
    
    if let result = String(data: output.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8){
        let recordArray: [String] = (result.components(separatedBy: .newlines))
        let serverArray: [String] = recordArray.map({ String($0.split(separator: " ").last?.dropLast() ?? "") }).dropLast()
        return(serverArray[0])
    } else {
        return nil
    }
}

print(getDomainControllerAddress()!)
