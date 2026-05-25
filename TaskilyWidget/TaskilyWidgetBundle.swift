//
//  TaskilyWidgetBundle.swift
//  TaskilyWidget
//
//  Created by Issa Abubakar on 23/05/2026.
//

import WidgetKit
import SwiftUI

@main
struct TaskilyWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskilyWidget()
        FilterableTaskListWidget()
    }
}
