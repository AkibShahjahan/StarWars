//
//  DetailViewController.swift
//  StarWars LS
//
//  Created by Akib Shahjahan on 2020-07-28.
//  Copyright © 2020 Akib Shahjahan. All rights reserved.
//

import UIKit
import TinyNetworking

class DetailViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var detail: Person?
    var tableDetails: Array<Array<String>> = [[], []]
    var filmURLs: Array<String> = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        populatePersonalDetails()
        populateFilms()
    }
    
    /**
        Sets delegate and datasource for the tableView and modifies design
    */
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .white
    }
    
    /**
        Add personal details of the Star Wars'  character to the tableView
    */
    func populatePersonalDetails() {
        tableDetails[0].append("Name: " + (detail?.name ?? "-"))
        tableDetails[0].append("Birth Year: " + (detail?.birth_year ?? "-"))
        tableDetails[0].append("Height: " + (detail?.height ?? "-"))
        tableDetails[0].append("Mass: " + (detail?.mass ?? "-"))
        tableDetails[0].append("Hair Color: " + (detail?.hair_color ?? "-"))
        tableDetails[0].append("Eye Color: " + (detail?.eye_color ?? "-"))
        tableView.reloadData()
    }
    
    /**
        Fetches all the films and poulates the Film's section of the tableView
    */
    func populateFilms() {
        filmURLs = detail?.films ?? []
        for url in filmURLs {
            let endpoint = Endpoint(json: .get, url: URL(string: url)!) as Endpoint<Film>
            URLSession.shared.load(endpoint) { result in
                do {
                    let ocCount = try self.wordCount(openingCrawl: result.get().opening_crawl)
                    
                    try self.tableDetails[1].append(result.get().title + " (" + String(ocCount) + ")")

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                    // Films List will  remain empty if network call fails or response is empty
                }
            }
        }
    }
    
    /**
        Counts the number of words in a given string
        - Parameter openingCrawl:  The string that needs a word count
        - Returns: An integer value for the word count of the given string
    */
    func wordCount(openingCrawl: String) -> Int{
        let words = openingCrawl.split { !$0.isLetter }
        return words.count
    }
    
}

// MARK: - TableView Delegate and DataSource function implementation

extension DetailViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDetails[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0; // Gets Rid of Line Limit
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = tableDetails[indexPath.section][indexPath.row]
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Personal Details"
        } else {
            return "Films"
        }
    }
    
}
