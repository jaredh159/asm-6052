// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "Asm6052",
  dependencies: [],
  targets: [
    .executableTarget(name: "Asm6052", dependencies: []),
    .testTarget(name: "Asm6052Tests", dependencies: ["Asm6052"]),
  ]
)
