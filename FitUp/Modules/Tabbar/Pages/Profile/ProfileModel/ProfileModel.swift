//
//  ProfileModel.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.06.25.
//
import Foundation
import UIKit

enum ProfileSection: Int, CaseIterable {
    case header
    case aiTrainer
    case optionsMenu

       var itemCount: Int {
           switch self {
           case .header: return 0
           case .aiTrainer: return 1
           case .optionsMenu: return 3
           }
       }
}
// MARK: - Mock Data для заглушек
struct MockUserProfile {
    static let defaultProfile = UserProfile(
        name: "Aysu",
        avatarImage: UIImage(systemName: "person.circle.fill"),
        stats: ProfileStats(record: 15, calorie: 1250, minute: 45)
    )
    static let menuOptions: [MenuOption] = [
        MenuOption(icon: UIImage(systemName: "dumbbell.fill"), title: "My Workouts", subtitle: "History • Recent"),
        MenuOption(icon: UIImage(systemName: "fork.knife"), title: "My Meal", subtitle: "History • Recent"),
        MenuOption(icon: UIImage(systemName: "icloud.and.arrow.up.fill"), title: "Backup & Restore", subtitle: "")
    ]
}
//struct OptionItem {
//    let icon: UIImage?
//    let title: String
//    let subtitle: String
//}
struct MenuOption {
    let icon: UIImage?
    let title: String
    let subtitle: String?
}

struct UserProfile {
    let name: String
    let avatarImage: UIImage?
    let stats: ProfileStats
}

struct ProfileStats {
    let record: Int
    let calorie: Int
    let minute: Int
}

