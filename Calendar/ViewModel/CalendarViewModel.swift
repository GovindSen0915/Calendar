//
//  ViewModel.swift
//  Calendar
//
//  Created by Govind Sen on 08/09/23.
//

import Foundation
import JTAppleCalendar
import ReactiveSwift

protocol CalendarViewModelDelegate: AnyObject {
    func reload()
}

enum CalendarSelectionType {
    case multiSelection
    case singleSelection
}

class CalendarViewModel {
    var view: CalendarViewModelDelegate?
    var startDate: Date
    var endDate: Date
    var selectionType: CalendarSelectionType
    var sectionModels = MutableProperty<[SectionModel]>([])
    var cellModels = MutableProperty<[Any]>([])
    var selectedDate: Date = Date()
    var monthData: Date?
    
    init(_ view: CalendarViewModelDelegate,_ selectionType: CalendarSelectionType = .multiSelection) {
        self.view = view
        self.startDate = Date()
        self.endDate = Date()
        self.selectionType = selectionType
        self.prepareCellModel()
    }
    
    func prepareCellModel() {
        
        self.sectionModels.value = []
        self.cellModels.value = []
        
        var dates = DateHelper.getDaysSimple(for: self.selectedDate)
        dates = dates.filter({ $0.day() >= selectedDate.day() })
        
        let dateModels = dates.map({ NewCellModel(day: $0, leave: "Hello there") })
        
        self.sectionModels.value = [SectionModel(headerModel: nil, cellModels: dateModels, footerModel: nil)]
        
        self.view?.reload()
    }
}

extension CalendarViewModel: CalendarViewControllerDelegate {
    
    func updatedata(date: Date) {
        
    }
    
    func didSelectDate(_ startDate: Date, _ endDate: Date) {
        
    }
    
    var numberOfSections: Int {
        return self.sectionModels.value.count
    }
    
    func itemAt(indexPath: IndexPath) -> Any {
        return self.sectionModels.value[indexPath.section].cellModels[indexPath.row]
    }
    
    func numberOfItemsAt(section: Int) -> Int {
        return self.sectionModels.value[section].cellModels.count
    }
    
    func setupData(selectedDate: Date) {
        //        self.prepareCellModel(date: selectedDate)
        self.selectedDate = selectedDate
        self.prepareCellModel()
    }
    
    //    func goToTodaysDate(currentDate: Date) -> Date {
    //        return currentDate.addDay(0)
    //    }
    
    
}

class SectionModel {
    var headerModel: Any?
    var cellModels: [Any]
    var footerModel: Any?
    
    init(headerModel: Any? = nil, cellModels: [Any], footerModel: Any? = nil) {
        self.headerModel = headerModel
        self.cellModels = cellModels
        self.footerModel = footerModel
    }
}


extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

