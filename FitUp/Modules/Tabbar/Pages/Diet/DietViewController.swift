//
//  DietViewController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.03.25.
//
import UIKit

class DietViewController: UITableViewController {
    private let albums = ["Vacation 2023", "Family Photos", "Work Projects", "Nature Shots"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Nutrition"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = albums[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "photo")
        return cell
    }
}
