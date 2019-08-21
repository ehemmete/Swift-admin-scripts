#!/usr/bin/swift

import Foundation

# update the path to point to the approprite file
# change dictionary["Client-ID"] for the appropriate top level key
# more good examples https://developer.apple.com/swift/blog/?id=37

let path = "/path/to/test.json"
let fileURL = URL(fileURLWithPath: path)
let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
let json = try? JSONSerialization.jsonObject(with: data, options: [])

if let dictionary = json as? [String: Any] {
	if let clientID = dictionary["Client-ID"] as? String {
		print(clientID)
	}
}
