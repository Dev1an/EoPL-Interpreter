//
//  LexicalDataTypes.swift
//  EoPL Interpreter
//
//  Created by Damiaan on 30/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

public enum LexicalExpression {
	public typealias Identifier = Int
	
	indirect case difference(LexicalExpression, LexicalExpression)
	indirect case isZero(LexicalExpression)
	indirect case `if`(condition: LexicalExpression, positive: LexicalExpression, negative: LexicalExpression)
	indirect case `let`(LexicalExpression, body: LexicalExpression)
	indirect case proc(body: LexicalExpression)
	indirect case call(proc: LexicalExpression, argument: LexicalExpression)
	case constant(Int)
	case variable(Identifier)
	
	public enum Value {
		case number(Int)
		case boolean(Bool)
		case procedure(body: LexicalExpression, Environment)
	}
	
	public typealias Environment = [Value]
}

public enum StaticEnvironment {
	indirect case extend(Expression.Identifier, StaticEnvironment)
	case end
}
