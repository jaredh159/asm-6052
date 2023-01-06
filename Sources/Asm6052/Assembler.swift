import Parsing

let ex = """
*     OBJ $300
      ORG $300
BELL  EQU $FBDD
*
START JSR BELL ; RING BELL
END   RTS      ; RETURN
"""

enum Address {
  case immediate(Byte)
  case zeroPage(Byte)
  case absolute(Byte, Byte)
}

struct HexParser: ParserPrinter {
  func print(_ output: Int, into input: inout Substring) throws {
    input = String(output, radix: 16).uppercased()[...]
  }

  typealias Input = Substring
  typealias Output = Int

  func parse(_ input: inout Input) throws -> Output {
    var iterator = input.makeIterator()
    var output = 0
    var success = false
    while let next = iterator.next() {
      if next.isHexDigit, let value = next.hexDigitValue {
        success = true
        input.removeFirst()
        output = output * 16 + value
      } else if success {
        return output
      } else {
        throw "parsing error"
      }
    }
    if success {
      return output
    } else {
      throw "parsing error"
    }
  }
}

let address = Parse {
  "$"
  HexParser()
}

let immediate = Parse {
  "#"
  address
}
