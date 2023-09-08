//
//  NewTableViewCell.swift
//  New_Proj
//
//  Created by Nickelfox on 12/04/23.
//

import UIKit

class NewTableViewCell: TableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var leaveLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()    }

    override func configure(_ item: Any?) {
        guard let model = item as? NewCellModel else { return }
        self.dayLabel.text = DateHelper.date(fromDate: model.day, format: .dMMM)
        self.leaveLabel.text = model.leave
    }
}

class TableViewCell: UITableViewCell {

    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }

    weak var delegate: NSObjectProtocol?

    func configure(_ item: Any?) {

    }

}


