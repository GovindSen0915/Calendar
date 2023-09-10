//
//  ViewController.swift
//  Calendar
//
//  Created by Govind Sen on 08/09/23.
//

import UIKit
import JTAppleCalendar

protocol CalendarViewControllerDelegate: AnyObject {
    var selectionType: CalendarSelectionType { get }
    var numberOfSections: Int { get }
    func numberOfItemsAt(section: Int) -> Int
    func itemAt(indexPath: IndexPath) -> Any
    func setupData(selectedDate: Date)
}

protocol CalendarViewControllerProtocol: AnyObject {
    func didSelectDate(date: Date)
}


extension CalendarViewControllerDelegate {
    var selectionType: CalendarSelectionType {
        return .multiSelection
    }
}


class CalendarViewController: UIViewController {
    
    @IBOutlet weak var collectionView: JTACMonthView!
    @IBOutlet var weekHeaderLabels: [UILabel]!
    @IBOutlet var monthAndYearLabel: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goToTodayButton: UIButton!
    
    var numberOfRows = 6
    var viewModel: CalendarViewControllerDelegate!
    
    private var scrolledDate: Date = Date()
    private var dateRange = DateRange(startDate: Date().addYear(0),
                                      endDate: Date().addYear(1))
    
    private let expandableCell = CalendarDateCell()
    
    var selectedDate: Date? {
        willSet {
            if let isDateRepeated = self.selectedDate?
                .isEqualToDate(newValue) {
                if !isDateRepeated {
                    self.selectDate(date: newValue)
                }
            }
        }
    }
    
    var chosenDate = Date()
    var selectedDateRange: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupViewModel()
        self.setupTableView()
        collectionView.scrollDirection = .horizontal
        collectionView.scrollingMode   = .stopAtEachCalendarFrame
        collectionView.showsHorizontalScrollIndicator = false
        
        self.addUpGesture()
        self.addDownGesture()
        self.addLeftGesture()
        self.addRightGesture()
        
        self.scrollToDate(date: Date(),animateScroll: false)
        
        self.goToTodayButton.layer.borderColor = .init(red: 0, green: 0, blue: 1, alpha: 0);   self.goToTodayButton.layer.borderWidth = 1
        self.goToTodayButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let date = DateHelper.date(fromDate: Date(),
                                   format: .MMMMyyyy)
        self.monthAndYearLabel.text = date
    }
    
    private func setupViewModel() {
        if self.viewModel == nil {
            self.viewModel = CalendarViewModel(self)
        }
    }
    
    func addUpGesture() {
        let up = UISwipeGestureRecognizer(target : self, action : #selector(SwipeUp))
        up.direction = .up
        self.collectionView.addGestureRecognizer(up)
    }
    
    func addDownGesture() {
        let down = UISwipeGestureRecognizer(target : self, action : #selector(SwipeDown))
        down.direction = .down
        self.collectionView.addGestureRecognizer(down)
    }
    
    func addLeftGesture() {
        let left = UISwipeGestureRecognizer(target : self, action : #selector(swipeLeft))
        left.direction = .right
        self.collectionView.addGestureRecognizer(left)
        
    }
    
    func addRightGesture() {
        let right = UISwipeGestureRecognizer(target : self, action : #selector(swipeRight))
        right.direction = .left
        self.collectionView.addGestureRecognizer(right)
    }
    
    @objc func SwipeUp() {
        if numberOfRows == 6 {
            self.constraint.constant = 58.33
            self.numberOfRows = 1
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                self.collectionView.reloadData(withAnchor: Date())
            }
        }
    }
    
    @objc func SwipeDown() {
        if numberOfRows == 1  {
            self.constraint.constant = 199
            self.numberOfRows = 6
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.collectionView.reloadData(withAnchor: Date())
            })
        }
    }
    
    @objc func swipeLeft() {
        self.addMonth(-1)
    }
    
    @objc func swipeRight() {
        self.addMonth(1)
    }
    
    @IBAction func scrollCalendarBackwardAction(_ sender: UIButton) {
        self.addMonth(-1)
    }
    
    @IBAction func scrollCalendarForwardAction(_ sender: UIButton) {
        self.addMonth(1)
    }
    
    @IBAction func toggle(_ sender: Any) {
        if numberOfRows == 6 {
            self.constraint.constant = 58.33
            self.numberOfRows = 1
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                self.collectionView.reloadData(withAnchor: Date())
            }
        } else {
            self.constraint.constant = 350
            self.numberOfRows = 6
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.collectionView.reloadData(withAnchor: Date())
            })
        }
    }
    
    @IBAction func goToTodayButtonAction(_ sender: UIButton) {
        self.scrollToDate(date: Date(),animateScroll: false)
        self.selectedDate = Date()
        self.viewModel.setupData(selectedDate: Date())
        
    }
    
    
}

// MARK: JTACMonthViewDelegate, JTACMonthViewDataSource
extension CalendarViewController: JTACMonthViewDataSource,
                                  JTACMonthViewDelegate {
    
    private func setupCollectionView() {
        self.collectionView.minimumLineSpacing = 0
        self.collectionView.minimumInteritemSpacing = 0
        self.collectionView.calendarDelegate = self
        self.collectionView.calendarDataSource = self
        self.collectionView.scrollDirection = .horizontal
        self.collectionView.scrollingMode = .stopAtEachCalendarFrame
        self.collectionView.isScrollEnabled = false
        self.collectionView.registerCell(CalendarDateCell.self)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendar.JTACMonthView) -> ConfigurationParameters {
        let startDate = self.dateRange.startDate
        let endDate = self.dateRange.endDate
        
        if numberOfRows == 6 {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: numberOfRows,
                                           calendar: Calendar.current,
                                           //                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           firstDayOfWeek: .sunday,
                                           hasStrictBoundaries: true)
        } else {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: 1,
                                           //                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           hasStrictBoundaries: true)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, cellForItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
        let identifier = CalendarDateCell.reuseIdentifier
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: identifier, for: indexPath) as? CalendarDateCell else {
            return JTACDayCell()
        }
        cell.configureCell(cellState, state: self.getState(date))
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, willDisplay cell: JTAppleCalendar.JTACDayCell, forItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) {
    }
    
    // MARK: Did Select
    func calendar(_ calendar: JTACMonthView,
                  didSelectDate date: Date,
                  cell: JTACDayCell?,
                  cellState: CellState,
                  indexPath: IndexPath) {
        self.selectedDate = date
        print("Date selected: ", self.selectedDate!)
        self.chosenDate = date
        print("Date chosen: ", self.chosenDate)
        if self.viewModel.selectionType == .singleSelection {
            let dates = self.selectedDate?.getWeekDates()
            self.selectedDateRange = dates ?? []
        }
        self.collectionView.reloadData()
        self.viewModel.setupData(selectedDate: date)
    }
    
}

// MARK: Extension
extension CalendarViewController {
    
    func setupVisibleDates(_ visibleDates: DateSegmentInfo) {
        let dates = visibleDates.monthDates
        if let startDate = dates.first?.date {
            let date = DateHelper.date(fromDate: startDate,
                                       format: .MMMMyyyy)
            self.monthAndYearLabel.text = date
        }
    }
    
    private func scrollToDate(date: Date,
                              animateScroll: Bool) {
        if self.collectionView.calendarDelegate != nil,
           self.collectionView.calendarDataSource != nil {
            self.collectionView
                .scrollToDate(date, triggerScrollToDateDelegate: false, animateScroll: animateScroll) {
                    self.collectionView.visibleDates { visibleDates in
                        self.setupVisibleDates(visibleDates)
                    }
                }
        }
        
    }
    
    private func getState(_ date: Date) -> DayCellState {
        if self.selectedDateRange.contains(date) || date == self.chosenDate {
            return .selected
        }
        if date.isToday {
            return .today
        }
        return .unselected
    }
    
    private func addMonth(_ month: Int) {
        self.scrolledDate = self.scrolledDate.addMonth(month)
        self.scrollToDate(date: self.scrolledDate,
                          animateScroll: true)
    }
    
    private func selectDate(date: Date?) {
        guard let date = date else {
            return
        }
        self.collectionView.reloadData()
    }
}

// MARK: CalendarViewModelDelegate
extension CalendarViewController: CalendarViewModelDelegate {
    func reload() {
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCell(NewTableViewCell.self)
        self.tableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsAt(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NewTableViewCell") as? NewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.item = self.viewModel.itemAt(indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    
    
}
