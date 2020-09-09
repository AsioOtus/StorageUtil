import XCTest
import Foundation

class Item_macOSTests: XCTestCase {
	static let itemPrefix = "com.multitool.userdefaults.unittest"
	
	override func setUp () {
		MTUserDefaults.settings =
			.init(
				items: .init(
					itemKeyPrefixProvider: Self.itemPrefix,
					logging: .init(
						enable: true,
						enableValuesLogging: true,
						loggingProvider: MTUserDefaults.StandardLoggingProvider()
					)
				)
			)
	}
	
	
	
	
	
	func testStringSaving () throws {
		let key = "testUserDefaultStringItemSaving"
		let testStringValue = "testStringValue"
		let encodedTestStringValue = try JSONEncoder().encode(testStringValue)
		
		MTUserDefaults.Item<String>(key).save(testStringValue)
				
		let loadedValue = UserDefaults.standard.data(forKey: "\(Self.itemPrefix).\(key)")!
		XCTAssert(loadedValue == encodedTestStringValue)
	}
	
	func testIntSaving () throws {
		let key = "testUserDefaultIntItemSaving"
		let testStringValue = 123
		let encodedTestStringValue = try JSONEncoder().encode(testStringValue)
		
		MTUserDefaults.Item<Int>(key).save(testStringValue)
		
		let loadedValue = UserDefaults.standard.data(forKey: "\(Self.itemPrefix).\(key)")!
		XCTAssert(loadedValue == encodedTestStringValue)
	}
	
	func testDataSaving () throws {
		let key = "testUserDefaultDataItemSaving"
		let testStringValue = Data([0x00, 0x01, 0x02])
		let encodedTestStringValue = try JSONEncoder().encode(testStringValue)
		
		MTUserDefaults.Item<Data>(key).save(testStringValue)
		
		let loadedValue = UserDefaults.standard.data(forKey: "\(Self.itemPrefix).\(key)")!
		XCTAssert(loadedValue == encodedTestStringValue)
	}
	
	
	
	
	
	func testStringLoading () throws {
		let key = "testUserDefaultStringItemLoading"
		let testStringValue = "testStringValue"
		
		let testItem = MTUserDefaults.Item<String>(key)
		testItem.save(testStringValue)
		let loadedValue = testItem.load()
		
		XCTAssert(loadedValue == testStringValue)
	}
	
	func testIntLoading () throws {
		let key = "testUserDefaultIntItemLoading"
		let testStringValue = 123
		
		let testItem = MTUserDefaults.Item<Int>(key)
		testItem.save(testStringValue)
		let loadedValue = testItem.load()
		
		XCTAssert(loadedValue == testStringValue)
	}
	
	func testDataLoading () throws {
		let key = "testUserDefaultDataItemLoading"
		let testStringValue = Data([0x00, 0x01, 0x02])
		
		let testItem = MTUserDefaults.Item<Data>(key)
		testItem.save(testStringValue)
		let loadedValue = testItem.load()
		
		XCTAssert(loadedValue == testStringValue)
	}
}
