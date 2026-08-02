//
//  FitTrackTests.swift
//  FitTrackTests
//
//  Created by Andres De La Cruz on 8/1/26.
//

import XCTest
@testable import FitTrack

@MainActor
final class FitTrackTests: XCTestCase {

    var vm: AppViewModel!

    override func setUpWithError() throws {
        vm = AppViewModel(startingCredits: 10)
    }

    // MARK: - Live Demo: Bug 1 (given, already written)
    // This test is RED against the starter AppViewModel. We fix it together
    // as the model demo before you start the solo exercises.
    
    func test_addCredits_preventsNegativeAmounts() {
        vm.addCredits(-5)
        XCTAssertEqual(vm.availableCredits, 10,
            "Adding a negative amount should be ignored, not subtract credits.")
    }

    // MARK: - Exercise 1: Bug 2 (isClassBooked by day, not just name) — TODO
    // Write a test proving Monday Yoga and Tuesday Yoga are treated as
    // DIFFERENT bookings, then fix AppViewModel.isClassBooked to make it pass.

    func test_isClassBooked_distinguishesSameNameOnDifferentDays() {
        let mondayYoga = vm.allClasses.first { $0.name == "Yoga" && $0.day == .monday }!
        let tuesdayYoga = vm.allClasses.first { $0.name == "Yoga" && $0.day == .tuesday }!
        
        vm.bookClass(mondayYoga)
        
        XCTAssertTrue(vm.isClassBooked(mondayYoga))
        XCTAssertFalse(vm.isClassBooked(tuesdayYoga))
     }

    // MARK: - Exercise 2: Bug 3 (insufficient credits) — TODO
    // Write a test proving bookClass() refuses to book when the user doesn't
    // have enough credits, then fix AppViewModel.bookClass to make it pass.
    
     func test_bookClass_refusesWhenInsufficientCredits() {
         let lowCreditVM = AppViewModel(
            startingCredits: 1,
            allClasses: [FitnessClass(name: "Spin", day: .monday, creditCost: 3)]
         )
         
         let spin = lowCreditVM.allClasses.first!
         lowCreditVM.bookClass(spin)
         
         XCTAssertFalse(lowCreditVM.isClassBooked(spin))
         XCTAssertEqual(lowCreditVM.availableCredits, 1)
     }

    // MARK: - Exercise 3
    
    func test_totalCreditsSpent_onlyCountsBookedClasses() {
        let monday = vm.allClasses.first { $0.day == .monday }!
        vm.bookClass(monday)
        XCTAssertEqual(vm.availableCredits, 8)
    }
    
    
    // MARK: - Exercise 4: Optimize the suite — TODO
    // The two tests below are redundant: they exercise the exact same
    // behavior (booking Monday Yoga deducts its cost) with only cosmetic
    // differences. Pick ONE to keep, delete the other, and give the
    // survivor a name that clearly states what it verifies.
    
    func test_bookClass_deductsCreditCost() {
        let monday = vm.allClasses.first { $0.day == .monday }!
        vm.bookClass(monday)
        XCTAssertEqual(vm.availableCredits, 8)
    }

    // MARK: - Exercise 5: Fix the flaky async test — TODO
    // This test "works" but is flaky: Thread.sleep is a guess about how long
    // purchaseCredits() takes, and on a slow CI runner 0.3s may not be enough.
    // Rewrite it using XCTestExpectation (or `await` directly, since
    // purchaseCredits is async) instead of a hardcoded sleep.
    
    func test_purchaseCredits_addsCreditsToBalance() async {
        await vm.purchaseCredits(5)
        XCTAssertEqual(vm.availableCredits, 15)
    }

    // MARK: - Exercise 6: cancelBooking — TODO
    
     func test_cancelBooking_removesClassAndRefundsCredits() {
         let monday = vm.allClasses.first { $0.day == .monday }!
         vm.bookClass(monday)
         vm.cancelBooking(monday)
         XCTAssertFalse(vm.isClassBooked(monday))
         XCTAssertEqual(vm.availableCredits, 10)
     }

    // MARK: - Exercise 7 (breather): bookingError messaging — TODO
    
     func test_bookClass_setsErrorMessage_whenInsufficientCredits() {
         let lowCreditVM = AppViewModel (
             startingCredits: 1,
             allClasses: [FitnessClass(name: "Spin", day: .monday, creditCost: 3)]
         )
         let spin = lowCreditVM.allClasses.first!
         lowCreditVM.bookClass(spin)
         XCTAssertNotNil(lowCreditVM.bookingError)
         XCTAssertEqual(lowCreditVM.bookingError, "Not enough credits to book Spin")
     }
}
