#!/usr/bin/swift
import Foundation
import OpenDirectory

var stUsers: [String] = []

let command = Process()
let output = Pipe()

command.launchPath = "/usr/sbin/diskutil"
command.arguments = ["apfs", "listUsers", "/", "-plist"]
command.standardOutput = output
command.launch()
command.waitUntilExit()

let plist = output.fileHandleForReading.readDataToEndOfFile()
let decodedPlist = try PropertyListSerialization.propertyList(from: plist, options:PropertyListSerialization.ReadOptions(), format:nil)
let decodedDict = decodedPlist as! Dictionary<String, AnyObject> 
let userList = decodedDict["Users"]!
let userArray = userList as! [Dictionary<String, String>]
let matchingArray: [Dictionary<String, String>] = userArray.filter { $0["APFSCryptoUserType"] == "LocalOpenDirectory" }
let guids: [String] = matchingArray.map { $0["APFSCryptoUserUUID"]! }

for guid in guids {
	do{
		if guid == "FFFFEEEE-DDDD-CCCC-BBBB-AAAA000000C9" {
            stUsers.append("Local Open Directory macOS Guest User")
		} else {
			let query = try ODQuery(node: ODNode(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes)),
								forRecordTypes: kODRecordTypeUsers,
								attribute: kODAttributeTypeGUID,
								matchType: ODMatchType(kODMatchEqualTo),
								queryValues: guid,
								returnAttributes: kODAttributeTypeNativeOnly,
								maximumResults: 1)
			let records = try query.resultsAllowingPartial(false) as! [ODRecord]
            stUsers.append(records.first?.recordName ?? "noUserFound")
		}
	} catch {
        stUsers.append("No User Found")
	}
}

print("<result>\(stUsers.joined(separator: "\n"))</result>")
