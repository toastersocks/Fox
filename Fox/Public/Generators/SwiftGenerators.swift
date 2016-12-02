import Foundation

// WARNING: please view this Swift API as ALPHA
//          it is subjected to change

// MARK: Array Generators

public func tuple(_ generators: FOXSequence) -> FOXGenerator {
    return FOXTupleOfGenerators(generators)
}

public func tuple(_ generators: [FOXGenerator]) -> FOXGenerator {
    return FOXTuple(generators)
}

public func array(_ elementGenerator: FOXGenerator) -> FOXGenerator {
    return FOXArray(elementGenerator)
}

public func array(_ elementGenerator: FOXGenerator, numberOfElements: UInt) -> FOXGenerator {
    return FOXArrayOfSize(elementGenerator, numberOfElements)
}

public func array(_ elementGenerator: FOXGenerator, minimumSize: UInt, maximumSize: UInt) -> FOXGenerator {
    return FOXArrayOfSizeRange(elementGenerator, minimumSize, maximumSize)
}

// MARK: Core Generators

public func genPure(_ tree: FOXRoseTree) -> FOXGenerator {
    return FOXGenPure(tree)
}

public func genMap(_ generator: FOXGenerator, mapfn: @escaping (FOXRoseTree) -> FOXRoseTree) -> FOXGenerator {
    return FOXGenMap(generator) { tree in
        return mapfn(tree!)
    }
}

public func map(_ generator: FOXGenerator, fn: @escaping (Any?) -> Any?) -> FOXGenerator {
    return FOXMap(generator) { value in
        return fn(value)
    }
}

public func bind(_ generator: FOXGenerator, fn: @escaping (Any?) -> FOXGenerator) -> FOXGenerator {
    return FOXBind(generator) { (value: Any?) in
        return fn(value!)
    }
}

public func choose(_ lowerBound: Int, upperBound: Int) -> FOXGenerator {
    return FOXChoose(lowerBound as NSNumber!, upperBound as NSNumber!)
}

public func sized(_ factory: @escaping (UInt) -> FOXGenerator) -> FOXGenerator {
    return FOXSized(factory)
}

public func returns(_ value: AnyObject!) -> FOXGenerator {
    return FOXReturn(value)
}

public func suchThat(_ generator: FOXGenerator, maxTries: UInt = 3, predicate: @escaping (Any!) -> Bool) -> FOXGenerator {
    return FOXSuchThatWithMaxTries(generator, predicate, maxTries)
}

public func oneOf(_ generators: [FOXGenerator]) -> FOXGenerator {
    return FOXOneOf(generators)
}

public func elements(_ elements: [AnyObject?]) -> FOXGenerator {
    return FOXElements(elements)
}

public func frequency(_ pairs: (UInt, FOXGenerator)...) -> FOXGenerator {
    var objcPairs: [Any] = []
    for (freq, gen) in pairs {
        objcPairs.append([freq, gen])
    }
    return FOXFrequency(objcPairs)
}

public func resize(_ generator: FOXGenerator, newSize: UInt) -> FOXGenerator {
    return FOXResize(generator, newSize)
}

public func resize(_ generator: FOXGenerator, minimumSize: UInt, maximumSize: UInt) -> FOXGenerator {
    return FOXResizeRange(generator, minimumSize, maximumSize)
}

// MARK: Dictionary Generators

public func dictionary(_ template: NSDictionary) -> FOXGenerator {
    return FOXDictionary(template as! [AnyHashable: Any])
}

// MARK: Numeric Generators

public func boolean() -> FOXGenerator {
    return FOXBoolean()
}

public func integer() -> FOXGenerator {
    return FOXInteger()
}

public func positiveInteger() -> FOXGenerator {
    return FOXPositiveInteger()
}

public func negativeInteger() -> FOXGenerator {
    return FOXNegativeInteger()
}

public func strictPositiveInteger() -> FOXGenerator {
    return FOXStrictPositiveInteger()
}

public func strictNegativeInteger() -> FOXGenerator {
    return FOXStrictNegativeInteger()
}

public func float() -> FOXGenerator {
    return FOXFloat()
}

public func double() -> FOXGenerator {
    return FOXDouble()
}

public func decimalNumber() -> FOXGenerator {
    return FOXDecimalNumber()
}

// MARK: Property Generators

public func forAll(_ dataType: FOXGenerator, then: @escaping (Any!) -> Bool) -> FOXGenerator {
    return FOXForAll(dataType, then)
}

public func forSome(_ dataType: FOXGenerator, then: @escaping (Any!) -> FOXPropertyStatus) -> FOXGenerator {
    return FOXForSome(dataType, then)
}

// MARK: Set Generators

public func set(_ elementGenerator: FOXGenerator) -> FOXGenerator {
    return FOXSet(elementGenerator)
}

// MARK: State Machine Generators

public func commands(_ stateMachine: FOXStateMachine) -> FOXGenerator {
    return FOXCommands(stateMachine)
}

public func executeCommands(_ stateMachine: FOXStateMachine, subjectFactory: @escaping () -> AnyObject!) -> FOXGenerator {
    return FOXExecuteCommands(stateMachine, subjectFactory)
}

public func executedSuccessfully(_ commands: NSArray) -> Bool {
    return FOXExecutedSuccessfully(commands as [AnyObject])
}

// MARK: String Generators

public func character() -> FOXGenerator {
    return FOXCharacter()
}

public func alphabeticalCharacter() -> FOXGenerator {
    return FOXAlphabeticalCharacter()
}

public func numericCharacter() -> FOXGenerator {
    return FOXNumericCharacter()
}

public func alphanumericCharacter() -> FOXGenerator {
    return FOXAlphanumericCharacter()
}

public func asciiCharacter() -> FOXGenerator {
    return FOXAsciiCharacter()
}

public func string() -> FOXGenerator {
    return FOXString()
}

public func string(_ length: UInt) -> FOXGenerator {
    return FOXStringOfLength(length);
}

public func string(_ minimumLength: UInt, maximumLength: UInt) -> FOXGenerator {
    return FOXStringOfLengthRange(minimumLength, maximumLength);
}

public func asciiString() -> FOXGenerator {
    return FOXAsciiString()
}

public func asciiString(_ length: UInt) -> FOXGenerator {
    return FOXAsciiStringOfLength(length)
}

public func asciiString(_ minimumLength: UInt, maximumLength: UInt) -> FOXGenerator {
    return FOXAsciiStringOfLengthRange(minimumLength, maximumLength)
}

public func alphabeticalString() -> FOXGenerator {
    return FOXAlphabeticalString()
}

public func alphabeticalString(_ length: UInt) -> FOXGenerator {
    return FOXAlphabeticalStringOfLength(length)
}

public func alphabeticalString(_ minimumLength: UInt, maximumLength: UInt) -> FOXGenerator {
    return FOXAlphabeticalStringOfLengthRange(minimumLength, maximumLength)
}

public func alphanumericString() -> FOXGenerator {
    return FOXAlphanumericString()
}

public func numericString() -> FOXGenerator {
    return FOXNumericString()
}

// MARK: Generic Generators

public func simpleType() -> FOXGenerator {
    return FOXSimpleType()
}

public func printableSimpleType() -> FOXGenerator {
    return FOXPrintableSimpleType()
}

public func compositeType(_ elementGenerator: FOXGenerator) -> FOXGenerator {
    return FOXCompositeType(elementGenerator)
}

public func anyObject() -> FOXGenerator {
    return FOXAnyObject()
}

public func anyPrintableObject() -> FOXGenerator {
    return FOXAnyPrintableObject()
}

