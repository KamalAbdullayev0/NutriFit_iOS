////
////  UsersViewController.swift
////  Netwrok
////
////  Created by Kamal Abdullayev on 08.03.25.
////
//import UIKit
//
//class UsersViewController: UITableViewController {
//    private let users = ["John Doe", "Jane Smith", "Alex Brown", "Emily Davis","Logout"]
//    var onLogoutTapped: (() -> Void)?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        title = "Profile"
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        users.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = users[indexPath.row]
//        cell.imageView?.image = UIImage(systemName: "person.circle")
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let selectedUser = users[indexPath.row]
//            if selectedUser == "Logout" {
//                onLogoutTapped?()
//                print("UsersViewController: Logout tapped") // ✅
//            }
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//}
