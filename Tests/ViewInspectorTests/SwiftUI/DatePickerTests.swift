import XCTest
import SwiftUI
@testable import ViewInspector

#if os(iOS) || os(macOS)

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
final class DatePickerTests: XCTestCase {
    
    class StateObject: ObservableObject {
        @Published var selectedDate1 = Date()
        @Published var selectedDate2 = Date()
    }
    @ObservedObject var state = StateObject()
    
    override func setUp() {
        state = StateObject()
    }
    
    func testEnclosedView() throws {
        let sampleView = Text("Test")
        let view = DatePicker(selection: $state.selectedDate1, label: { sampleView })
        let sut = try view.inspect().datePicker().labelView().text().content.view as? Text
        XCTAssertEqual(sut, sampleView)
    }
    
    func testResetsModifiers() throws {
        let view = DatePicker("Test", selection: $state.selectedDate1).padding()
        let sut = try view.inspect().datePicker().labelView().text()
        XCTAssertEqual(sut.content.modifiers.count, 0)
    }
    
    func testDeprecatedLabelInspection() throws {
        let view = DatePicker("", selection: $state.selectedDate1)
        XCTAssertNoThrow(try view.inspect().datePicker().text())
    }
    
    func testExtractionFromSingleViewContainer() throws {
        let view = AnyView(DatePicker("Test", selection: $state.selectedDate1))
        XCTAssertNoThrow(try view.inspect().anyView().datePicker())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        let view = HStack {
            DatePicker("Test", selection: $state.selectedDate1)
            DatePicker("Test", selection: $state.selectedDate2)
        }
        XCTAssertNoThrow(try view.inspect().hStack().datePicker(0))
        XCTAssertNoThrow(try view.inspect().hStack().datePicker(1))
    }
}

// MARK: - View Modifiers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
final class GlobalModifiersForDatePicker: XCTestCase {
    
    func testDatePickerStyle() throws {
        let sut = EmptyView().datePickerStyle(DefaultDatePickerStyle())
        XCTAssertNoThrow(try sut.inspect().emptyView())
    }
    
    func testDatePickerStyleInspection() throws {
        let sut = EmptyView().datePickerStyle(DefaultDatePickerStyle())
        XCTAssertTrue(try sut.inspect().datePickerStyle() is DefaultDatePickerStyle)
    }
}

#endif
