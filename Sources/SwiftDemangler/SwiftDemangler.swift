public func demangle(name: String) -> String {
//    return name //TODO: implement
    let parser = Parser.init(name: name)
    _ = parser.parsePrefix()
    return parser.parseFunctionEntity().description
}

private func isSwiftSymbol(name: String) -> Bool {
    return name.hasPrefix("$S")
}

private func isFunctionEntitySpec(name: String) -> Bool {
    return name.hasSuffix("F")
}

struct FunctionSignature: Equatable {
    let returnType: Type
    let argsType: Type
}

struct FunctionEntity: Equatable, CustomStringConvertible {
    let module: String
    let declName: String
    let labelList: [String]
    let functionSignature: FunctionSignature

    var description: String {
        // ExampleNumber.isEven(number: Swift.Int) -> Swift.Bool

        let argumentsString: String
        switch functionSignature.argsType {
        case .list(let types):
            let elements = zip(labelList, types).map { (label, type) -> String in
                return "\(label): \(type.displayName)"
            }.joined(separator: ",")
            argumentsString = "(" + elements + ")"
        default:
            fatalError()
        }

        return module + "." + declName + argumentsString + " -> " + functionSignature.returnType.displayName
    }
}

enum Type: Equatable {
    case bool
    case int
    case string
    case float
    indirect case list([Type])

    init(name: String) {
        switch name {
        case "i":
            self = .int
        case "b":
            self = .bool
        case "S":
            self = .string
        case "f":
            self = .float
        default:
            fatalError()
        }
        // todo: listサポート
    }

    var displayName: String {
        switch self {
        case .bool:
            return "Swift.Bool"
        case .float:
            return "Swift.Float"
        case .int:
            return "Swift.Int"
        case .string:
            return "Swift.String"
        case .list(let types):
            fatalError()
        }
    }
}
