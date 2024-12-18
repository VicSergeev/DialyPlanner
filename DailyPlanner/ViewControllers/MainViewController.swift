//
//  ViewController.swift
//  DailyPlanner
//
//  Created by Vic on 14.12.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDate = Date()
    var totalDaysInCalendar = [String]()
    var selectedDay: Int?      // Tracks which day user has selected
    var currentDate = Date()   // Stores the actual current date for reference
    var timeSlots: [String] = [] // Array to store time slots
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTimeSlots()
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHandler().increaseMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHandler().decreaseMonth(date: selectedDate)
        setMonthView()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

// MARK: - setup UI
extension MainViewController {
    
    func setupUI() {
        setupCells()
        setupTableView()
        // Initialize calendar with current date selected
        selectedDate = currentDate
        selectedDay = CalendarHandler().dayOfMonth(date: currentDate)
        setMonthView()
    }
    
    func setupCells() {
        // Calculate cell size to fit collection view
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // Register a cell if you're using a custom cell class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeSlotCell")
    }
    
    func setupTimeSlots() {
        timeSlots.removeAll()
        for hour in 0..<24 {
            let startHour = String(format: "%02d:00", hour)
            let endHour = String(format: "%02d:00", (hour + 1) % 24)
            timeSlots.append("\(startHour)-\(endHour)")
        }
    }
    
    func setMonthView() {
        totalDaysInCalendar.removeAll()
        
        let daysInMonth = CalendarHandler().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHandler().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHandler().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42) {
            if (count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalDaysInCalendar.append("")
            } else {
                totalDaysInCalendar.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarHandler()
            .monthString(date: selectedDate) + " " + CalendarHandler()
            .yearString(date: selectedDate)
        
        collectionView.reloadData()
        tableView.reloadData()
    }
}

// MARK: - UICollction view setup
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - DataSource part
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalDaysInCalendar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonthLabel.text = totalDaysInCalendar[indexPath.item]
        
        // Reset cell appearance for reuse
        cell.backgroundColor = .clear
        cell.dayOfMonthLabel.textColor = .black
        
        // Make cell circular
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.clipsToBounds = true
        
        // highlight current day if we're viewing the current month and year
        if let day = Int(totalDaysInCalendar[indexPath.item]),
           CalendarHandler().monthString(date: selectedDate) == CalendarHandler().monthString(date: currentDate),
           CalendarHandler().yearString(date: selectedDate) == CalendarHandler().yearString(date: currentDate),
           day == CalendarHandler().dayOfMonth(date: currentDate) {
            // current day highlight
            cell.backgroundColor = .systemBlue
            cell.dayOfMonthLabel.textColor = .white
        }
        
        // highlight other selected day
        if let selectedDay = selectedDay,
           let day = Int(totalDaysInCalendar[indexPath.item]),
           day == selectedDay {
            // selected day highlight
            cell.backgroundColor = .systemGreen
            cell.dayOfMonthLabel.textColor = .white
        }
        
        return cell
    }
    
    // MARK: - Delegate part
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let day = Int(totalDaysInCalendar[indexPath.item]) {
            selectedDay = day
            collectionView.reloadData()
        }
    }
}

// MARK: - UITableView Setup
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//        cell.textLabel?.text = timeSlots[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // Standard cell height
    }
}
