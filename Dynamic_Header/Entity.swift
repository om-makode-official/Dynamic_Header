//
//  Entity.swift
//  Dynamic_Header
//
//  Created by Sai Krishna on 2/12/26.
//

import Foundation
import SwiftUI


enum TopSectionEnum: Int, CaseIterable {

    case first = 0
    case second
    case third

    var title: String {
        switch self {
        case .first:
            return "Dip IFR"
        case .second:
            return "2nd Page"
        case .third:
            return "3rd Page"
        }
    }

    var image: String {
        switch self {
        case .first:
            return "pic2"
        case .second:
            return "pic2"
        case .third:
            return "pic2"
        }
    }

    var gradient: LinearGradient {
        switch self {

        case .first:
            return LinearGradient(
                colors: [Color(hex:"#205188"), Color(hex:"#64AEDE")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .second:
            return LinearGradient(
                colors: [.purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .third:
            return LinearGradient(
                colors: [.red, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
