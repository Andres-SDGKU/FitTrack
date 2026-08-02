//
//  AppViewModel.swift
//  FitTrack
//
//  Created by Andres De La Cruz on 8/1/26.
//

import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    @Published var availableCredits: Int
    @Published var bookedClasses: [FitnessClass] = []
    @Published var bookingError: String? = nil
    @Published var isPurchasing: Bool = false

    let allClasses: [FitnessClass]
    private let creditStore: CreditPurchasing

    init(startingCredits: Int = 10,
         allClasses: [FitnessClass]? = nil,
         creditStore: CreditPurchasing = MockCreditStore()) {
        self.availableCredits = startingCredits
        self.allClasses = allClasses ?? [
            FitnessClass(name: "Yoga", day: .monday, creditCost: 2),
            FitnessClass(name: "Yoga", day: .tuesday, creditCost: 2),
            FitnessClass(name: "HIIT", day: .wednesday, creditCost: 3)
        ]
        self.creditStore = creditStore
    }

    // MARK: Class#6 Bug 1 — fixed together in the live demo.
    // Doesn't guard against non-positive amounts: addCredits(-5) SUBTRACTS credits.
    func addCredits(_ amount: Int) {
        guard amount > 0 else { return }
        availableCredits += amount
    }

    // MARK: Class#6 Bug 2 — Exercise 1.
    // Compares by `name` only, so it can't tell Monday Yoga from Tuesday Yoga apart.
    func isClassBooked(_ fitnessClass: FitnessClass) -> Bool {
        bookedClasses.contains { $0.id == fitnessClass.id}
    }

    // MARK: Class#6 Bug 3 — Exercise 2.
    // Never checks whether the user has enough credits before booking.
    func bookClass(_ fitnessClass: FitnessClass) {
        guard !isClassBooked(fitnessClass) else {
            bookingError = "You've already booked \(fitnessClass.name) on \(fitnessClass.day.rawValue)"
            return
        }
        guard availableCredits >= fitnessClass.creditCost else {
            bookingError = "Not enough credits to book \(fitnessClass.name)"
            return
        }
        bookedClasses.append(fitnessClass)
        availableCredits -= fitnessClass.creditCost
        bookingError = nil
    }

    // MARK: Class#6 Debugging drill — Exercise 3 (no fix needed yet, diagnose first).
    // Looks correct at a glance, but sums the cost of EVERY class in the catalog,
    // not just the ones the user actually booked. Set a breakpoint here and use
    // `po allClasses` / `po bookedClasses` in LLDB to see the mismatch.
    var totalCreditsSpent: Int {
        bookedClasses.reduce(0) { $0 + $1.creditCost }
    }

    // MARK: Class#6 Exercise 6 (breather) — TODO: implement.
    // Should remove the class from bookedClasses AND refund its creditCost.
    // Do nothing if the class isn't currently booked.
    func cancelBooking(_ fitnessClass: FitnessClass) {
        guard isClassBooked(fitnessClass) else { return }
        bookedClasses.removeAll { $0.id == fitnessClass.id}
        availableCredits += fitnessClass.creditCost
    }

    // MARK: Class#6 Exercise 7 (breather) — TODO: extend.
    // bookClass should set `bookingError` with a user-facing message whenever
    // booking fails (already booked, or insufficient credits), and clear it
    // (set to nil) on a successful booking.

    // Given/complete infrastructure for Exercise 5 (flaky async test fix).
    func purchaseCredits(_ amount: Int) async {
        isPurchasing = true
        defer { isPurchasing = false }
        if let purchased = try? await creditStore.purchase(amount: amount) {
            addCredits(purchased)
        }
    }
}
