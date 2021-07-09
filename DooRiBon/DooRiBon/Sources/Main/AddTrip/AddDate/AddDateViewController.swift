//
//  AddDateViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/07.
//

import UIKit
import FSCalendar

class AddDateViewController: UIViewController {

    //MARK:- IBOutlet
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var bottomBoxView: UIView!
    
    //MARK:- Variable
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    fileprivate var dooriCalendar = Calendar(identifier: .gregorian)
    var delegate: dateLabelProtocol?
    
    var startString = ""
    var endString = ""
    var startDateLabelData = ""
    var endDateLabelData = ""
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        calendarSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = calendar.frame
        rectShape.position = calendar.center
        rectShape.path = UIBezierPath(roundedRect: calendar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        calendar.layer.mask = rectShape
    }
    
    //MARK:- IBAction
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectButtonClicked(_ sender: Any) {
        self.delegate?.startEndDateLabelSet(start: startDateLabelData, end: endDateLabelData)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Function
    
    func configureUI() {
        mainLabel.text = "번들님 여행 날짜는\n언제인가요?"
        selectButton.isEnabled = false
        bottomBoxView.layer.applyShadow(color: .black, alpha: 0.04, x: 0, y: -3, blur: 10, spread: 0)
    }
    
    func calendarSet() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        calendar.scrollDirection = .vertical
        calendar.hasFloatingWeekdayView = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.scrollWhenSelected = false
        calendar.appearance.headerSeparatorColor = Colors.gray7.color
        calendar.appearance.weekdayTextColor = Colors.gray5.color
        calendar.appearance.weekdayWeekendTextColor = Colors.subOrange1.color
        calendar.appearance.titleFont = UIFont.SpoqaHanSansNeo(.bold, size: 12)
        calendar.appearance.titleWeekendColor = Colors.pointOrange.color
        calendar.appearance.weekdayFont = UIFont.SpoqaHanSansNeo(.bold, size: 12)
        calendar.appearance.headerTitleColor = Colors.subBlue2.color
        calendar.appearance.headerDateFormat = "M"
        calendar.appearance.headerTitleLeftMargin = 31
        calendar.appearance.headerSubtitleRightMargin = 29
        calendar.appearance.hasHeaderSubtitle = true
        calendar.appearance.headerTitleFont = UIFont.SpoqaHanSansNeo(.bold, size: 23)
        calendar.appearance.headerSubtitleFont = UIFont.SpoqaHanSansNeo(.regular, size: 12)
        calendar.appearance.headerTitleSuffixFont = UIFont.SpoqaHanSansNeo(.regular, size: 12)
        calendar.appearance.headerSuffixString = "월"
        calendar.appearance.headerSubtitleColor = Colors.subBlue2.color
        calendar.appearance.headerTitleSuffixColor = Colors.subBlue2.color
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        dooriCalendar.locale = Locale(identifier: "ko_KR")
    }
}

//MARK:- Protocol

protocol dateLabelProtocol {
    func startEndDateLabelSet(start: String, end: String)
}

//MARK:- Extension

extension AddDateViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        /// nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [date]
            let dateComponents = dooriCalendar.dateComponents([.year, .month, .day, .weekday], from: date)
            guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day, let weekIndex = dateComponents.weekday else { return }
            let dayOfWeek = dooriCalendar.weekdaySymbols[weekIndex-1]
            startString = String(format: "%d. %02d. %02d", year, month, day)
            startDateLabelData = "\(startString) \(dayOfWeek)"
            self.selectButton.setTitle(startString, for: .normal)
            self.selectButton.setTitleColor(Colors.gray4.color, for: .normal)
            self.selectButton.backgroundColor = Colors.gray7.color
            self.selectButton.borderWidth = 0
            self.configureVisibleCells()
            return
        }

        /// only first date is selected:
        if let first = firstDate, lastDate == nil {
            if date <= first {
                calendar.deselect(first)
                firstDate = date
                datesRange = [first]

                let dateComponents = dooriCalendar.dateComponents([.year, .month, .day, .weekday], from: date)
                guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else { return }
                startString = String(format: "%d. %02d. %02d", year, month, day)
                self.selectButton.setTitle("\(startString)", for: .normal)
                self.configureVisibleCells()
                return
            }

            let range = datesRange(from: first, to: date)
            lastDate = range.last
            for d in range {
                calendar.select(d)
            }
            datesRange = range
            let dateComponents = dooriCalendar.dateComponents([.year, .month, .day, .weekday], from: date)
            guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day, let weekIndex = dateComponents.weekday else { return }
            let dayOfWeek = dooriCalendar.weekdaySymbols[weekIndex-1]
            endString = String(format: "%d. %02d. %02d", year, month, day)
            endDateLabelData = "\(endString) \(dayOfWeek)"
            self.selectButton.setTitle("\(startString) - \(endString) 등록하기", for: .normal)
            self.selectButton.setTitleColor(Colors.pointOrange.color, for: .normal)
            self.selectButton.backgroundColor = Colors.white9.color
            self.selectButton.borderWidth = 1
            self.selectButton.borderColor = Colors.pointOrange.color
            self.configureVisibleCells()
            self.selectButton.isEnabled = true
            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            self.configureVisibleCells()
            self.selectButton.setTitle("시작과 끝나는 날짜를 눌러주세요", for: .normal)
            self.selectButton.setTitleColor(Colors.gray4.color, for: .normal)
            self.selectButton.backgroundColor = Colors.gray7.color
            self.selectButton.borderWidth = 0
            self.selectButton.isEnabled = false
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        for d in calendar.selectedDates {
            calendar.deselect(d)
        }
        lastDate = nil
        firstDate = nil
        datesRange = []
        configureVisibleCells()
        self.selectButton.setTitle("시작과 끝나는 날짜를 눌러주세요", for: .normal)
        self.selectButton.setTitleColor(Colors.gray4.color, for: .normal)
        self.selectButton.backgroundColor = Colors.gray7.color
        self.selectButton.borderWidth = 0
        self.selectButton.isEnabled = false
    }

    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            if let date = Calendar.current.date(byAdding: .day, value: 1, to: tempDate) {
                tempDate = date
                array.append(tempDate)
            }
        }
        return array
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        guard let diyCell = cell as? CalendarCell else { return }
        if position == .current {
            var selectionType = SelectionType.none
            if calendar.selectedDates.contains(date) {
                let previousDate = self.dooriCalendar.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.dooriCalendar.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            diyCell.selectionType = selectionType
        } else {
            diyCell.selectionType = .none
        }
    }
}
