public func demangle(name: String) -> String {
    return name //TODO: implement
}

private func isSwiftSymbol(name: String) -> Bool {
    return name.hasPrefix("$S")
}

private func isFunctionEntitySpec(name: String) -> Bool {
    return name.hasSuffix("F")
}
