import Foundation

struct LabelBuilder {
	private init () { }
	
	static func build (_ itemType: String, _ file: String, _ line: Int, _ uuid: UUID) -> String {
		"\(Info.moduleName).\(itemType) – \(file):\(line) – \(uuid.uuidString)"
	}
}
