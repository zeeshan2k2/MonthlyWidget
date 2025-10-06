//
//  MonthlyWidgetBundle.swift
//  MonthlyWidget
//
//  Created by Zeeshan Waheed on 06/10/2025.
//

import WidgetKit
import SwiftUI

@main
struct MonthlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        MonthlyWidgetControl()
        MonthlyWidgetLiveActivity()
    }
}
