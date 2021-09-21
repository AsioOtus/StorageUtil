import Foundation

public struct IdentificationInfo: Codable, CustomStringConvertible {
	public let moduleId: String?
	public let typeId: String
	public let definitionId: String
	public let instanceId: String
	public let alias: String?
	
	public var description: String {
		"\(moduleId.flatMap{ "\($0)." } ?? "")\(typeId) – \(definitionId) – alias: \(alias.flatMap{ "\($0)." } ?? "") – \(instanceId)"
	}
	
	public var shortDescription: String {
		"\(moduleId.flatMap{ "\($0)." } ?? "")\(typeId).\(instanceId)"
	}
	
	public var typeDescription: String {
		"\(moduleId.flatMap{ "\($0)." } ?? "")\(typeId)"
	}
	
	init (_ moduleId: String? = nil, typeId: String, file: String, line: Int, alias: String? = nil) {
		self.moduleId = Info.moduleName
		self.typeId = typeId
		self.definitionId = "\(file):\(line)"
		self.instanceId = UUID().uuidString
		self.alias = alias
	}
}

