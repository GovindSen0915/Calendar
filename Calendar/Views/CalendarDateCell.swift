//
//  CalendarDateCell.swift
//  Calendar
//
//  Created by Govind Sen on 08/09/23.
//

import UIKit
import JTAppleCalendar

struct DateRange {
    var startDate: Date
    var endDate: Date
}

enum DayCellState {
    case today
    case selected
    case unselected
}

protocol CalendarDateCellDelegate: AnyObject {
    func goToTodaysDate(_ date: Date)
    
}

class CalendarDateCell: JTACDayCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 17
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.textColor = .clear
    }
    
    func configureCell(_ cellState: CellState,
                       state: DayCellState) {
        self.dateLabel.text = cellState.text
        //        self.isHighlighted = cellState.dateBelongsTo != .thisMonth
        
        var textColor: UIColor = .black
        var bgColor: UIColor = .white
        
        switch state {
        case .today:
            textColor = .white
            bgColor = .systemBlue
        case .selected:
            textColor = .white
            bgColor = .systemBlue
        case .unselected:
            textColor = .black
            bgColor = .white
            //        case .previ
        }
        
        if cellState.dateBelongsTo != .thisMonth {
            //            textColor = .gray // need to disable previous month date ,
            textColor = .white
        }
        
        self.dateLabel.textColor = textColor
        self.dateLabel.backgroundColor = bgColor
    }
}
