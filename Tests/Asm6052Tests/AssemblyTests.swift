import XCTest

@testable import Asm6052

final class AssemblyTests: XCTestCase {
  func testHexParser() throws {
    var input = "FF"[...]
    let parser = HexParser()
    let result = try parser.parse(&input)
    expect(result).toEqual(255)
  }

  func testAddressParser() throws {
    var input = "$FF"[...]
    let result = try address.parse(&input)
    expect(result).toEqual(255)
    let printed = try address.print(255)
    expect(String(printed)).toEqual("$FF")
  }

  func testImmediateParser() throws {
    var input = "#$FF"[...]
    let result = try immediate.parse(&input)
    expect(result).toEqual(255)
    let printed = try immediate.print(255)
    expect(String(printed)).toEqual("#$FF")
  }
}
