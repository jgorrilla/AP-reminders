//
//  Calender.swift
//  AP reminders
//
//  Created by 64005533 on 4/8/26.
//
import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let location: String
    let materials: String
}

struct Day: Identifiable {
    let id = UUID()
    let date: Date
    var events: [CalendarEvent]
}


let calendarDays: [Day] = (1...30).map { i in
    Day(
        date: Calendar.current.date(bySetting: .day, value: i, of: Date())!,
        events: []
    )
}
struct CalendarView: View {
    
    @State private var days: [Day] = []
    @State private var selectedDay: Day?
    @State private var showAddEvent = false
    @State private var currentMonth = Date()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack {
            
            // 🔹 Month label + Add button
            HStack {
                
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(currentMonthString())
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                }
                
                Button(action: {
                    showAddEvent = true
                }) {
                    Image(systemName: "plus")
                        .padding(.leading)
                }
            }
            .padding(.horizontal)
            
            // 🔹 Calendar grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(days.indices, id: \.self) { index in
                        let day = days[index]
                        
                        Button(action: {
                            selectedDay = day
                        }) {
                            Text("\(Calendar.current.component(.day, from: day.date))")
                                .frame(width: 40, height: 40)
                                .background(backgroundColor(for: day))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        
        // 🔹 Day detail popup
        .sheet(item: $selectedDay) { day in
            if let index = days.firstIndex(where: {
                Calendar.current.isDate($0.date, inSameDayAs: day.date)
            }) {
                DayDetailView(day: $days[index])
            }
        }
        // 🔹 Add event popup
        .sheet(isPresented: $showAddEvent) {
            AddEventView { newEvent, date in
                addEvent(newEvent, to: date)
            }
        }
        .onAppear {
            days = generateDays(for: currentMonth)
        }
    }
    // MARK: - Helpers
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            days = generateDays(for: newMonth)
        }
    }
    
    
    func currentMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: Date())
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func backgroundColor(for day: Day) -> Color {
        if isToday(day.date) {
            return Color.green.opacity(0.6) // 🔹 today highlight
        } else if !day.events.isEmpty {
            return Color.blue.opacity(0.5) // 🔹 has events
        } else {
            return Color.clear
        }
    }
    
    func addEvent(_ event: CalendarEvent, to date: Date) {
        for i in days.indices {
            if Calendar.current.isDate(days[i].date, inSameDayAs: date) {
                days[i].events.append(event)
            }
        }
    }
    func deleteEvent(_ event: CalendarEvent, from date: Date) {
        for i in days.indices {
            if Calendar.current.isDate(days[i].date, inSameDayAs: date) {
                days[i].events.removeAll { $0.id == event.id }
            }
        }
    }
    func generateDays(for date: Date) -> [Day] {
        let calendar = Calendar.current
        
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        
        return range.compactMap { day -> Day? in
            guard let fullDate = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) else { return nil }
            return Day(date: fullDate, events: [])
        }
    }
    

}
struct DayDetailView: View {
    
    @Binding var day: Day
    
    @State private var eventToDelete: CalendarEvent?
    @State private var showConfirm = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Events on \(formattedDate(day.date))")
                    .font(.title2)
                    .bold()
                
                if day.events.isEmpty {
                    Text("No events today!")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        ForEach(day.events) { event in
                            VStack(alignment: .leading, spacing: 8) {
                                
                                Text(event.title)
                                    .font(.headline)
                                
                                Text("Time: \(event.time)")
                                Text("Location: \(event.location)")
                                Text("Materials: \(event.materials)")
                                
                                Button(role: .destructive) {
                                    eventToDelete = event
                                    showConfirm = true
                                } label: {
                                    Text("Remove Event")
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            
            .confirmationDialog(
                "Are you sure?",
                isPresented: $showConfirm
            ) {
                Button("Delete", role: .destructive) {
                    if let event = eventToDelete {
                        delete(event)
                    }
                }
            }
        }
    }
    
    func delete(_ event: CalendarEvent) {
        day.events.removeAll { $0.id == event.id }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}
struct AddEventView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var time = ""
    @State private var location = ""
    @State private var materials = ""
    @State private var date = Date()
    
    var onSave: (CalendarEvent, Date) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Time", text: $time)
                TextField("Location", text: $location)
                TextField("Materials", text: $materials)
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            
            .navigationTitle("Add Event")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newEvent = CalendarEvent(
                            title: title,
                            time: time,
                            location: location,
                            materials: materials
                        )
                        
                        onSave(newEvent, date)
                        dismiss()
                    }
                }
            }
        }
    }
}
