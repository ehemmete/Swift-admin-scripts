#!/usr/bin/swift
import Foundation
let argCount = CommandLine.argc
if argCount != 3 {
    let commandName = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
    print("Usage: \(commandName) key preferenceDomain")
    print("Example:")
    print("       \(commandName) orientation com.apple.Dock")
    exit(1)
}
let key = CommandLine.arguments[1] as CFString
let domain = CommandLine.arguments[2] as CFString
if let preference = CFPreferencesCopyAppValue(key, domain) {
	print("<result>\(preference)</result>")
} else {
	print(String("<result>No result found</result>"))
}
