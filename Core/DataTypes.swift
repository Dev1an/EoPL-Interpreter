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
	indirect case letrec(Identifier, argument: Identifier, Expression, body: Expression)
	indirect case proc(variable: Identifier, body: Expression)
	indirect case call(proc: Expression, argument: Expression)
	case constant(Int)
	case variable(Identifier)
}

public enum Environment {
	indirect case extend(Identifier, ExpressedValue, Environment)
	indirect case recursiveExtend(Identifier, Identifier, Expression, Environment)
	case end
}

public enum ExpressedValue {
	case number(Int)
	case boolean(Bool)
	case procedure(variable: Identifier, body: Expression, Environment)
}
