//
//  CreditService.swift
//  FitTrack
//
//  Created by Andres De La Cruz on 8/1/26.
//

import Foundation

protocol CreditPurchasing {
    func purchase(amount: Int) async throws -> Int
}

enum CreditPurchaseError: Error {
    case invalidAmount
}

/// Simulated backend for the "Buy Credits" flow.
/// The 0.4s delay stands in for a real network call — it exists purely to
/// make the loading state (`isPurchasing`) observable and testable, the
/// same pattern used for AuthService.login() in LoginKit (Class #4).
final class MockCreditStore: CreditPurchasing {
    func purchase(amount: Int) async throws -> Int {
        guard amount > 0 else { throw CreditPurchaseError.invalidAmount }
        try? await Task.sleep(nanoseconds: 400_000_000)
        return amount
    }
}
