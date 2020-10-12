import SwiftUI

// MARK: - Adjusting Text in a View

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public extension InspectableView {
    
    #if !os(macOS)
    func textContentType() throws -> UITextContentType? {
        let reference = EmptyView().textContentType(.emailAddress)
        let keyPath = try Inspector.environmentKeyPath(Optional<String>.self, reference)
        let value = try environmentModifier(keyPath: keyPath, call: "textContentType")
        return value.flatMap { UITextContentType(rawValue: $0) }
    }
    #endif

    #if os(iOS) || os(tvOS)
    func keyboardType() throws -> UIKeyboardType {
        let reference = EmptyView().keyboardType(.default)
        let referenceKeyPath = try Inspector.environmentKeyPath(Int.self, reference)
        let value = try modifierAttribute(modifierLookup: { modifier -> Bool in
            guard modifier.modifierType == "_EnvironmentKeyWritingModifier<Int>",
                  let keyPath = try? Inspector.environmentKeyPath(Int.self, modifier)
            else { return false }
            return keyPath == referenceKeyPath
        }, path: "modifier|value", type: Int.self, call: "keyboardType")
        return UIKeyboardType(rawValue: value)!
    }
    
    func autocapitalization() throws -> UITextAutocapitalizationType {
        let reference = EmptyView().autocapitalization(.none)
        let referenceKeyPath = try Inspector.environmentKeyPath(Int.self, reference)
        let value = try modifierAttribute(modifierLookup: { modifier -> Bool in
            guard modifier.modifierType == "_EnvironmentKeyWritingModifier<Int>",
                  let keyPath = try? Inspector.environmentKeyPath(Int.self, modifier)
            else { return false }
            return keyPath == referenceKeyPath
        }, path: "modifier|value", type: Int.self, call: "autocapitalization")
        return UITextAutocapitalizationType(rawValue: value)!
    }
    #endif
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
internal extension InspectableView {
    func environmentModifier<T>(keyPath reference: WritableKeyPath<EnvironmentValues, T>, call: String) throws -> T {
        let name = Inspector.typeName(type: T.self)
        return try modifierAttribute(modifierLookup: { modifier -> Bool in
            guard modifier.modifierType == "_EnvironmentKeyWritingModifier<\(name)>",
                  let keyPath = try? Inspector.environmentKeyPath(T.self, modifier)
            else { return false }
            return keyPath == reference
        }, path: "modifier|value", type: T.self, call: call)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
internal extension Inspector {
    static func environmentKeyPath<T>(_ type: T.Type, _ value: Any) throws -> WritableKeyPath<EnvironmentValues, T> {
        return try Inspector.attribute(path: "modifier|keyPath", value: value,
                                       type: WritableKeyPath<EnvironmentValues, T>.self)
    }
}