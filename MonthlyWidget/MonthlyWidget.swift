//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Zeeshan Waheed on 06/10/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DayEntry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of 7 entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate list containing the contexts this widget is relevant in.
//    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

struct MonthlyWidgetEntryView : View {
    var entry: DayEntry
    var config: MonthConfig
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Text(config.emojiText)
                Text(entry.date.weekdayDisplayFormat)
                    .font(.title3)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(config.weekdayTextColor)
                Spacer()
            }
            
            Text(entry.date.dayDisplayFormat)
                .font(.system(size: 80, weight: .heavy))
                .foregroundColor(config.dayTextColor)
        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
        }
    }
}

struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        // to test different dates
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            MonthlyWidgetEntryView(entry: DayEntry(date: MonthlyWidget.dateToDisplay(month: 4, day: 22)))
//        }
    
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes")
        .supportedFamilies([.systemSmall])
    }
    
    // to test
    static func dateToDisplay(month: Int, day: Int) -> Date {
        let components = DateComponents(
            calendar: Calendar.current,
            year: 2025,
            month: month,
            day: day
        )
        
        return Calendar.current.date(from: components)!
    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    DayEntry(date: .now)
    DayEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)
}



extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}
