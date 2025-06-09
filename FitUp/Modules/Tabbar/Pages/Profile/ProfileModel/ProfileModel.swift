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
struct MockNetworkData {

    /// Моковые данные для профиля пользователя, имитирующие ответ от бэкенда.
    static let userProfileDTO = UserProfileDTO(
        id: 101,
        fullName: "Камал Абдуллаев",
        username: "kamal_dev",
        profileImageUrl: "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260", // Пример URL изображения
        gender: "male",
        age: 28,
        height: 182.5,
        weight: 81.3,
        goal: "muscle_gain", // Цель: набор массы
        activityLevel: "moderately_active" // Уровень активности: умеренно активный
    )

    /// Моковые данные для пищевых потребностей, имитирующие ответ от бэкенда.
    static let nutritionRequirementsDTO = NutritionRequirementsDTO(
        calories: 2500,
        protein: 180,
        carbs: 250,
        fat: 80,
        sugar: 60
    )
}

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

