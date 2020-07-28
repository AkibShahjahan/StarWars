//
//  ViewControllerTests.swift
//  StarWars LSTests
//
//  Created by Akib Shahjahan on 2020-07-28.
//  Copyright © 2020 Akib Shahjahan. All rights reserved.
//

import XCTest
import TinyNetworking
@testable import StarWars_LS

class ViewControllerTests: XCTestCase {

    var vc: ViewController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        _ = vc?.view // calls the viewDidLoad
    }

    override func tearDown() {
        super.tearDown()
    }

    /// Tests whether tableView is initialized properly in the ViewController
    func testInitTableView() {
        XCTAssertNotNil(vc?.tableView)
        XCTAssertTrue(vc?.tableView.dataSource is ViewController)
        XCTAssertTrue(vc?.tableView.delegate is ViewController)
    }
    
    /// Tests whether tableView is empty when there is no data
    func testTableViewEmpty() {
        vc?.people = []
        vc?.tableView.reloadData()
        
        XCTAssertTrue(vc?.tableView.numberOfSections == 1)
        XCTAssertTrue(vc?.tableView.numberOfRows(inSection: 0) == 0)
    }

    /// Tests whether tableView is populated properly with Star Wars' character names
    func testTableViewPopulation() {
        let person1 = Person(name: "Bob the Builder", birth_year: "1990", height: "170", mass: "150", hair_color: "black", eye_color: "brown", films: [])
        let person2 = Person(name: "Luke Skywalker", birth_year: "XXXX", height: "200", mass: "320", hair_color: "black", eye_color: "Orange", films: [])
        let person3 = Person(name: "Lando Calrissian", birth_year: "", height: "", mass: "", hair_color: "", eye_color: "", films: [])
        
        vc?.people = [person1, person2, person3]
        vc?.tableView.reloadData()
        
        XCTAssertTrue(vc?.tableView.numberOfSections == 1)
        XCTAssertTrue(vc?.tableView.numberOfRows(inSection: 0) == 3)
        
        var indexPath = IndexPath(row: 0, section: 0)
        var cell = vc?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Bob the Builder")
        
        indexPath = IndexPath(row: 1, section: 0)
        cell = vc?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Luke Skywalker")
        
        indexPath = IndexPath(row: 2, section: 0)
        cell = vc?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Lando Calrissian")
    }
    
    
}

