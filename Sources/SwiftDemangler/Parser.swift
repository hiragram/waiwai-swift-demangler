//
//  Parser.swift
//  SwiftDemangler
//
//  Created by yuya-hirayama on 2018/12/16.
//

import Foundation

class Parser {
    private let name: String
    private var index: String.Index

    var remains: String {
        return String(name[index...])
    }

    init(name: String) {
        self.name = name
        self.index = name.startIndex
    }

    private func parseInt() -> Int? {
        var integerStr = ""

        for char in remains {
            if let integerChar = Int.init(String.init(char)) {
                integerStr.append(String.init(integerChar))
            } else {
                break
            }
        }

        index = name.index(index, offsetBy: integerStr.count)

        return Int.init(integerStr)
    }

    private func parseIdentifier(length: Int) -> String {
        let identifier = String.init(remains.prefix(length))

        index = name.index(index, offsetBy: length)

        return identifier
    }

    func parseIdentifier() -> String? {
        if let length = parseInt() {
            return parseIdentifier(length: length)
        } else {
            return nil
        }
    }

    func parsePrefix() -> String {
        let prefix = "$S"
        assert(remains.hasPrefix(prefix))

        index = name.index(index, offsetBy: prefix.count)

        return prefix
    }

    func parseModule() -> String {
        return parseIdentifier()!
    }

    func parseDeclName() -> String {
        return parseIdentifier()!
    }

    func parseLabelList() -> [String] {
        var labels: [String] = []
        while let label = parseIdentifier() {
            labels.append(label)
        }

        return labels
    }
}
