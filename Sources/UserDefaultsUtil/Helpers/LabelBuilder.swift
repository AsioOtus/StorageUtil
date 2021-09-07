import Foundation

struct LabelBuilder {
	private init () { }
	
	static func build (_ itemType: String, _ file: String, _ line: Int) -> String {
		"\(Info.moduleName).\(itemType) – \(file):\(line) – \(UUID().uuidString)"
	}
}
