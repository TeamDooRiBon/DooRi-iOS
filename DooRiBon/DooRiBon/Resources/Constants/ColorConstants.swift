// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

internal enum Colors {
    internal static let backgroundBlue = ColorAsset(name: "backgroundBlue")
    internal static let black1 = ColorAsset(name: "black1")
    internal static let black2 = ColorAsset(name: "black2")
    internal static let black3 = ColorAsset(name: "black3")
    internal static let gray4 = ColorAsset(name: "gray4")
    internal static let gray5 = ColorAsset(name: "gray5")
    internal static let gray6 = ColorAsset(name: "gray6")
    internal static let gray7 = ColorAsset(name: "gray7")
    internal static let pointBlue = ColorAsset(name: "pointBlue")
    internal static let pointOrange = ColorAsset(name: "pointOrange")
    internal static let subBlue1 = ColorAsset(name: "subBlue1")
    internal static let subBlue2 = ColorAsset(name: "subBlue2")
    internal static let subBlue3 = ColorAsset(name: "subBlue3")
    internal static let subDarkBlue = ColorAsset(name: "subDarkBlue")
    internal static let subOrange1 = ColorAsset(name: "subOrange1")
    internal static let subOrange2 = ColorAsset(name: "subOrange2")
    internal static let subOrangeLight = ColorAsset(name: "subOrangeLight")
    internal static let white8 = ColorAsset(name: "white8")
    internal static let white9 = ColorAsset(name: "white9")
    internal static let gray_black2 = ColorAsset(name: "grayblack2")
    internal static let kakao = ColorAsset(name: "kakao")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
