import XCTest

@testable import Asm6052

final class Asm6052Tests: XCTestCase {
  func test1Plus1Is2() throws {
    var cpu = Cpu()
    try cpu.execute(byteCode: [
      0xA9, // LDA (Immediate)
      0x01, // operand
      0x69, // ADC (Immediate)
      0x01, // operand
    ])
    expect(cpu.accum.value).toEqual(0x02)
    expect(cpu.carryFlag).toBeFalse()

    cpu = Cpu()
    try cpu.execute(operations: [
      .LDA_IM(0x01),
      .ADC_IM(0x01),
    ])
    expect(cpu.accum.value).toEqual(0x02)
    expect(cpu.carryFlag).toBeFalse()
  }

  func testOverflowSetsCarryFlag() throws {
    var cpu = Cpu()
    try cpu.execute(byteCode: [
      0xA9, // LDA (Immediate)
      0xFF, // operand
      0x69, // ADC (Immediate)
      0x01, // operand
    ])
    expect(cpu.accum.value).toEqual(0x00)
    expect(cpu.carryFlag).toBeTrue()

    cpu = Cpu()
    try cpu.execute(operations: [
      .LDA_IM(0xFF),
      .ADC_IM(0x01),
    ])
    expect(cpu.accum.value).toEqual(0x00)
    expect(cpu.carryFlag).toBeTrue()
  }

  func testSTA() throws {
    let cpu = Cpu()
    try cpu.execute(operations: [
      .LDA_IM(0x44),
      .STA_ZP(0x00),
    ])
    expect(cpu.heap[0x00].value).toEqual(0x44)
  }
}
