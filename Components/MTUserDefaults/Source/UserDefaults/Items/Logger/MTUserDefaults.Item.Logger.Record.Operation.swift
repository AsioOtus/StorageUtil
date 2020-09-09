extension MTUserDefaults.Item.Logger.Record {
	enum Operation {
		case saving(ItemType)
		case loading
		case deletion
		case existance
		
		var name: String {
			let name: String
			
			switch self {
			case .saving:
				name = "SAVING"
			case .loading:
				name = "LOADING"
			case .deletion:
				name = "DELETION"
			case .existance:
				name = "EXISTANCE"
			}
			
			return name
		}
		
		var value: ItemType? {
			let value: ItemType?
			
			if case .saving(let item) = self {
				value = item
			} else {
				value = nil
			}
			
			return value
		}
	}
}
