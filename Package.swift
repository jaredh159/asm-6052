// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "Asm6052",
  platforms: [.macOS(.v12)],
  dependencies: [
    .package("pointfreeco/swift-parsing@0.11.0"),
  ],
  targets: [
    .executableTarget(name: "Asm6052", dependencies: [
      .product(name: "Parsing", package: "swift-parsing"),
    ]),
    .testTarget(name: "Asm6052Tests", dependencies: ["Asm6052"]),
  ]
)

// helpers

extension PackageDescription.Package.Dependency {
  static func package(_ commitish: String, _ name: String? = nil) -> Package.Dependency {
    let parts = commitish.split(separator: "@")
    return .package(
      name: name,
      url: "https://github.com/\(parts[0]).git",
      from: .init(stringLiteral: "\(parts[1])")
    )
  }
}
