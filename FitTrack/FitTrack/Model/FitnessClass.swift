//
//  FitnessClass.swift
//  FitTrack
//
//  Created by Andres De La Cruz on 8/1/26.
//

import Foundation

enum Weekday: String, CaseIterable, Codable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
}

struct FitnessClass: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    let day: Weekday
    let creditCost: Int

    init(id: UUID = UUID(), name: String, day: Weekday, creditCost: Int) {
        self.id = id
        self.name = name
        self.day = day
        self.creditCost = creditCost
    }
}
