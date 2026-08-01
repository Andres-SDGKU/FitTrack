//
//  ContentView.swift
//  FitTrack
//
//  Created by Andres De La Cruz on 8/1/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("\(viewModel.availableCredits) credits")
                        .font(.largeTitle.bold())
                        .accessibilityIdentifier("credits_label")
                    Button("Buy 5 Credits") {
                        Task { await viewModel.purchaseCredits(5) }
                    }
                    .accessibilityIdentifier("buy_credits_button")
                    if viewModel.isPurchasing {
                        ProgressView().accessibilityIdentifier("purchase_loading_indicator")
                    }
                }
                .padding(.top)

                if let error = viewModel.bookingError {
                    Text(error)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("booking_error_label")
                }

                List(viewModel.allClasses) { fitnessClass in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(fitnessClass.name).font(.headline)
                            Text("\(fitnessClass.day.rawValue) · \(fitnessClass.creditCost) credits")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if viewModel.isClassBooked(fitnessClass) {
                            Button("Cancel") { viewModel.cancelBooking(fitnessClass) }
                                .accessibilityIdentifier("cancel_button_\(fitnessClass.name)_\(fitnessClass.day.rawValue)")
                        } else {
                            Button("Book") { viewModel.bookClass(fitnessClass) }
                                .accessibilityIdentifier("book_button_\(fitnessClass.name)_\(fitnessClass.day.rawValue)")
                        }
                    }
                }
                .accessibilityIdentifier("classes_list")
            }
            .navigationTitle("FitTrack")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}

