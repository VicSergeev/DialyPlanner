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
    
    var selectedDate = Date()
    var totalDaysInCalendar = [String]()
    var selectedDay: Int?      // Tracks which day user has selected
    var currentDate = Date()   // Stores the actual current date for reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        // Highlight current day if we're viewing the current month and year
        if let day = Int(totalDaysInCalendar[indexPath.item]),
           CalendarHandler().monthString(date: selectedDate) == CalendarHandler().monthString(date: currentDate),
           CalendarHandler().yearString(date: selectedDate) == CalendarHandler().yearString(date: currentDate),
           day == CalendarHandler().dayOfMonth(date: currentDate) {
            // Current day is highlighted in blue
            cell.backgroundColor = .systemBlue
            cell.dayOfMonthLabel.textColor = .white
        }
        
        // Highlight user selected day
        if let selectedDay = selectedDay,
           let day = Int(totalDaysInCalendar[indexPath.item]),
           day == selectedDay {
            // Selected day is highlighted in green
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
