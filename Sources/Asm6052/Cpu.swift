struct Byte: Equatable {
  let value: UInt8
}

extension Byte {
  init() {
    value = 0
  }

  init(_ value: UInt8) {
    self.value = value
  }
}

extension Byte: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.value = UInt8(value)
  }
}

extension Byte {
  static let ADC_IM = Byte(0x69)
  static let LDA_IM = Byte(0xA9)
  static let STA_ZP = Byte(0x85)
}

enum Operation {
  case ADC_IM(Byte)
  case LDA_IM(Byte)
  case STA_ZP(Byte)

  var byteCode: [Byte] {
    switch self {
    case .ADC_IM(let operand):
      return [.ADC_IM, operand]
    case .LDA_IM(let operand):
      return [.LDA_IM, operand]
    case .STA_ZP(let operand):
      return [.STA_ZP, operand]
    }
  }
}

extension Array where Element == Byte {
  subscript(_ index: UInt8) -> Byte {
    get { self[Int(index)] }
    set { self[Int(index)] = newValue }
  }
}

class Cpu {
  var accum = Byte()
  var xReg = Byte()
  var yReg = Byte()
  var heap: [Byte] = []
  var carryFlag = false
  var verbose = false

  // "With the 6502, the stack is always on page one ($100-$1FF) and works top down."

  init() {
    heap.reserveCapacity(0x100)
    for _ in 0 ..< 0x100 {
      heap.append(Byte(.random(in: 0 ... 0xFF))) // simulate garbage
    }
  }

  func execute(operations: [Operation]) throws {
    let byteCode = operations.flatMap(\.byteCode).map(\.value)
    try execute(byteCode: byteCode)
  }

  func execute(byteCode code: [UInt8]) throws {
    var code = code
    while !code.isEmpty {
      let op = Byte(code.removeFirst())
      switch op {
      case .ADC_IM:
        let operand = code.removeFirst()
        let (result, overflow) = accum.value.addingReportingOverflow(operand)
        if verbose { print("ADC, operand: \(operand)") }
        accum = Byte(value: result)
        carryFlag = overflow
      case .LDA_IM:
        let operand = code.removeFirst()
        if verbose { print("LDA, operand: \(operand)") }
        accum = Byte(value: operand)
      case .STA_ZP:
        let address = code.removeFirst()
        if verbose { print("STA, address: \(address)") }
        heap[address] = accum
      default:
        throw "Invalid opcode"
      }
    }
    // todo, empty array
  }
}

extension String: Error {} // temp
