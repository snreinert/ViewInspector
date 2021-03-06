import XCTest
import SwiftUI
@testable import ViewInspector

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 13.0, macOS 10.15, *)
@available(tvOS, unavailable)
final class ColorPickerTests: XCTestCase {
    
    func testInspect() throws {
        guard #available(iOS 14, macOS 11.0, *) else { return }
        let binding = Binding<CGColor>.init(wrappedValue: .test)
        XCTAssertNoThrow(try ColorPicker("Test", selection: binding).inspect())
    }
    
    func testExtractionFromSingleViewContainer() throws {
        guard #available(iOS 14, macOS 11.0, *) else { return }
        let binding = Binding<CGColor>.init(wrappedValue: .test)
        let view = AnyView(ColorPicker("Test", selection: binding))
        XCTAssertNoThrow(try view.inspect().anyView().colorPicker())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        guard #available(iOS 14, macOS 11.0, *) else { return }
        let binding = Binding<CGColor>.init(wrappedValue: .test)
        let view = HStack {
            Text("")
            ColorPicker("Test", selection: binding)
            Text("")
        }
        XCTAssertNoThrow(try view.inspect().hStack().colorPicker(1))
    }
    
    func testLabelInspection() throws {
        guard #available(iOS 14, macOS 11.0, *) else { return }
        let binding = Binding<Color>.init(wrappedValue: .red)
        let sut = ColorPicker(selection: binding, label: {
            HStack { Text("abc") }
        })
        let string = try sut.inspect().colorPicker().labelView().hStack().text(0).string()
        XCTAssertEqual(string, "abc")
    }
}

@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
private extension CGColor {
    static var test: CGColor {
        return CGColor(gray: 0.4, alpha: 0.9)
    }
}
#endif
