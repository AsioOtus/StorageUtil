import Foundation
import os

extension Keychain {
	public struct Logger {
		static func log (_ commit: Record.Commit) {
			let recordInfo = convert(commit)
			
			if let recordInfo = recordInfo {
				log(recordInfo)
			}
		}
		
		private static func convert (_ commit: Record.Commit) -> Record.Info? {
			guard
				Keychain.Settings.current.logging.enable &&
				commit.resolution.level.rawValue >= Keychain.Settings.current.logging.level.rawValue
			else { return nil }
			
			let keychainIdentifier = Keychain.Settings.current.logging.enableKeychainIdentifierLogging ? "Keychain" : nil
			let isExists = Keychain.Settings.current.logging.enableValuesLogging ? commit.resolution.isExists : nil
			let value = Keychain.Settings.current.logging.enableValuesLogging ? commit.value : nil
			let query = Keychain.Settings.current.logging.enableQueryLogging ? commit.query : nil
			
			let info = Record.Info(
				keychainIdentifier: keychainIdentifier,
				operation: commit.operation.name,
				existance: isExists,
				value: value,
				errorType: commit.resolution.errorType,
				error: commit.resolution.error,
				query: query,
				level: commit.resolution.level
			)
			
			return info
		}
		
		private static func log (_ recordInfo: Record.Info) {
			if let loggingProvider = Keychain.Settings.current.logging.loggingProvider {
				loggingProvider.log(recordInfo)
			}
		}
	}
}
