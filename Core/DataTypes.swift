//
//  DataTypes.swift
//  eopl
//
//  Created by Damiaan on 4/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

public typealias Identifier = String

public enum Expression {
	indirect case difference(Expression, Expression)
	indirect case isZero(Expression)
	indirect case `if`(condition: Expression, positive: Expression, negative: Expression)
	indirect case `let`(Identifier, Expression, body: Expression)
	case constant(Int)
	case variable(Identifier)
}

public enum Environment {
	indirect case extend(Identifier, ExpressedValue, Environment)
	case end
	
	subscript(query: Identifier) -> ExpressedValue {
		switch self {
		case let .extend(identifier, value, rest):
			return identifier == query ? value : rest[query]
		case .end: fatalError("identifier not found")
		}
	}
}

public enum ExpressedValue {
	case number(Int)
	case boolean(Bool)
	
	func toInt() -> Int {
		guard case .number(let number) = self else {fatalError("Not a number")}
		return number
	}
	
	func toBool() -> Bool {
		guard case .boolean(let boolean) = self else {fatalError("Not a boolean")}
		return boolean
	}
}
