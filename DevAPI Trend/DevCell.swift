//
//  DevCell.swift
//  DevAPI Trend
//
//  Created by Chang Tong Xue on 2016-01-23.
//  Copyright © 2016 DX. All rights reserved.
//

import UIKit

class DevCell: UITableViewCell {
    
    var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var detail: UILabel!
}
