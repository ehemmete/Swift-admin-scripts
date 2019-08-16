#!/usr/bin/swift
import Foundation
let key = CommandLine.arguments[1] as CFString
let domain = CommandLine.arguments[2] as CFString
if let preference = CFPreferencesCopyAppValue(key, domain) {
	print("<result>\(preference)</result>")
} else {
	print(String("<result>No result found</result>"))
}