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

        skip(length: integerStr.count)

        return Int.init(integerStr)
    }

    private func parseIdentifier(length: Int) -> String {
        let identifier = String.init(remains.prefix(length))

        skip(length: length)

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

        skip(length: prefix.count)

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

    // indexはそのままに一文字先読みする
    func peek() -> String? {
        return remains.dropFirst().first.map(String.init)
    }

    // length分だけindexを進める
    func skip(length: Int) {
        index = name.index(index, offsetBy: length)
    }

    func parseKnownType() -> Type {
        let type = Type.init(name: peek()!)
        skip(length: 2)
        return type
    }

    func parseListTypeElement() -> [Type] {
        if remains.first == "_" {
            skip(length: 1)
        }
        if remains.first == "t" {
            skip(length: 1)
            return []
        }
        let headType = parseKnownType()
        return [headType] + parseListTypeElement()
    }

    func parseType() -> Type {
        let headType = parseKnownType()

        if remains.first == "_" {
            return .list([headType] + parseListTypeElement())
        } else {
            return headType
        }
    }

    func parseFunctionSignature() -> FunctionSignature {
        let returnType = parseType()
        let argsType = parseType()

        return FunctionSignature.init(returnType: returnType, argsType: argsType)
    }

    func parseFunctionEntity() -> FunctionEntity {
        let module = parseModule()
        let declName = parseDeclName()
        let labelList = parseLabelList()
        let functionSignature = parseFunctionSignature()

        return FunctionEntity.init(
            module: module,
            declName: declName,
            labelList: labelList,
            functionSignature: functionSignature
        )
    }
}
