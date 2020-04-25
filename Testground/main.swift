import Keychain_macOS



print()



// START ----- ----- ----- ----- -----





Keychain.Settings.GenericPasswords.appIdentifier = "MTT"
Keychain.Settings.GenericPasswords.appIdentifier = "MTT"

let password = Keychain.ParametricGenericPassword<String, String>("password")
try password.save("P@ssw0rd", "user")
let query = [
kSecClass: kSecClassGenericPassword,
kSecAttrService: "Evernote"
	] as [CFString : Any]

var item: CFTypeRef?
let status = SecItemCopyMatching(query as CFDictionary, &item)

print(CFGetTypeID(item))


if (CFGetTypeID(item) == CFDataGetTypeID()) {
	//i haz a string
	print("AAA")
}

//let loadedPassword = try Keychain.load(query, String.self)
//print(loadedPassword)

//Keychain.clear()





// END ----- ----- ----- ----- -----



print()
print("END")
