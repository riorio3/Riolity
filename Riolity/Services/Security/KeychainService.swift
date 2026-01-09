import Foundation
import Security

/// Secure storage service using iOS Keychain
/// Never stores API keys in UserDefaults, code, or plain text
final class KeychainService {
    static let shared = KeychainService()

    private let service = "com.riolity.app"

    private init() {}

    // MARK: - API Key Management

    enum KeyType: String {
        case claudeAPI = "claude_api_key"
    }

    /// Save an API key securely to Keychain
    func saveAPIKey(_ key: String, type: KeyType) -> Bool {
        guard !key.isEmpty else { return false }

        let data = Data(key.utf8)

        // Delete existing key first
        deleteAPIKey(type: type)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: type.rawValue,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Retrieve an API key from Keychain
    func getAPIKey(type: KeyType) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: type.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }

        return key
    }

    /// Delete an API key from Keychain
    @discardableResult
    func deleteAPIKey(type: KeyType) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: type.rawValue
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    /// Check if an API key exists
    func hasAPIKey(type: KeyType) -> Bool {
        return getAPIKey(type: type) != nil
    }

    /// Validate API key format (basic check)
    func isValidAPIKeyFormat(_ key: String, type: KeyType) -> Bool {
        switch type {
        case .claudeAPI:
            // Claude API keys start with "sk-ant-"
            return key.hasPrefix("sk-ant-") && key.count > 20
        }
    }
}
