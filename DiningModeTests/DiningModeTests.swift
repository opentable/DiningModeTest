//
//  DiningModeTests.swift
//  DiningModeTests
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import DiningMode

extension ReservationAssembler {

}

class DiningModeTests: XCTestCase {

    func testFullReservation() {
        let url = Bundle.main.url(forResource: "FullReservation", withExtension:"json")
        let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

        guard let reservation = ReservationAssembler().createReservation(json) else {
            XCTFail("reservation was not built")
            return
        }

        XCTAssertNotNil(reservation.restaurant.profilePhoto)
        XCTAssertTrue(reservation.restaurant.dishes.count == 3)

        let firstDish = reservation.restaurant.dishes[0]
        XCTAssertNotEqual(firstDish.photos.count, 0)
        XCTAssertNotEqual(firstDish.snippet.highlights.count, 0)
    }

    func testTwoDishes() {
        let url = Bundle.main.url(forResource: "2dishes", withExtension:"json")
        let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

        guard let reservation = ReservationAssembler().createReservation(json) else {
            XCTFail("reservation was not built")
            return
        }

        XCTAssertNotNil(reservation.restaurant.profilePhoto)
        XCTAssertEqual(reservation.restaurant.dishes.count, 2)

        let firstDish = reservation.restaurant.dishes[0]
        XCTAssertNotEqual(firstDish.photos.count, 0)
        XCTAssertNotEqual(firstDish.snippet.highlights.count, 0)
    }

    func testPartialReservation() {
        let url = Bundle.main.url(forResource: "PartialReservation", withExtension:"json")
        let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

        guard let reservation = ReservationAssembler().createReservation(json) else {
            XCTFail("reservation was not built")
            return
        }

        XCTAssertNotNil(reservation.restaurant.profilePhoto)
        XCTAssertEqual(reservation.restaurant.dishes.count, 0)
    }

    func testFileAssemblerSuccess() {
        let fileName = "FullReservationSuccess"
        guard let reservation = ReservationAssembler().createReservation(fromJsonTerminatedFile: fileName) else {
            XCTFail("reservation was not created from file\(fileName)")
            return
        }
        XCTAssert(reservation.partySize == 2)
    }

    func testFileAssemblerFailBadFormat() {
        let fileName = "FullReservationFail"
        let reservation = ReservationAssembler().createReservation(fromJsonTerminatedFile: fileName)
        XCTAssertNil(reservation, "reservation should have failed because of a badly formatted file")
    }
}

