import SwiftUI

// MARK: - Models

struct CalendarEvent: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var time: String
    var location: String
    var materials: String
}

struct Month: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let days: [Date]
}

struct SelectedDate: Identifiable {
    let id = UUID()
    let date: Date
}

// MARK: - Main Calendar View

struct CalendarView: View {
    
    @State private var months: [Month] = []
    @State private var yearOffset: Int = 0
    
    @State private var selectedDate: SelectedDate?
    @State private var showAddEvent = false
    @State private var addEventDate = Date()
    
    @State private var eventsByDate: [Date: [CalendarEvent]] = [:]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Header
            HStack {
                Button { shiftYear(by: -1) } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(displayYearLabel())
                    .font(.title2)
                    .bold()

                Spacer()

                Button { shiftYear(by: 1) } label: {
                    Image(systemName: "chevron.right")
                }

                Button {
                    if let selected = selectedDate {
                        addEventDate = selected.date
                    } else {
                        addEventDate = Date()
                    }
                    showAddEvent = true
                } label: {
                    Image(systemName: "plus")
                        .padding(.leading, 12)
                }
            }
            .padding()

            Divider()

            // MARK: Calendar Scroll
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 28) {
                        ForEach(months) { month in
                            monthView(month)
                                .id(month.id)
                        }
                    }
                    .padding(.vertical, 16)
                }
                .onAppear {
                    loadMonths()
                    scrollToCurrentMonth(proxy: proxy)
                }
                .onChange(of: months) {
                    scrollToCurrentMonth(proxy: proxy)
                }
            }
        }
        .sheet(isPresented: $showAddEvent) {
            AddEventView(initialDate: addEventDate) { event, date in
                addEvent(event, to: date)
            }
        }
        .sheet(item: $selectedDate) { selection in
            DayDetailView(
                date: selection.date,
                events: eventsBinding(for: selection.date)
            )
        }
    }
    
    // MARK: - Month View
    
    private func monthView(_ month: Month) -> some View {
        VStack(spacing: 12) {
            
            Text(monthString(from: month.date))
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                ForEach(weekdaySymbols(), id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(0..<firstWeekdayOffset(for: month.date), id: \.self) { _ in
                    Color.clear.frame(height: 44)
                }

                ForEach(month.days, id: \.self) { date in
                    Button {
                        selectedDate = SelectedDate(date: date)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(backgroundColor(for: date))
                                .frame(height: 44)

                            Text("\(Calendar.current.component(.day, from: date))")
                                .foregroundColor(Calendar.current.isDateInWeekend(date) ? .red : .primary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Data Loading
    private func weekdaySymbols() -> [String] {
        let cal = Calendar.current
        let symbols = cal.shortWeekdaySymbols
        let start = cal.firstWeekday - 1
        
        return Array(symbols[start...]) + Array(symbols[..<start])
    }
    private func loadMonths() {
        months = generateMonths(for: currentYear())
    }

    private func shiftYear(by value: Int) {
        yearOffset += value
        loadMonths()
    }

    private func currentYear() -> Int {
        Calendar.current.component(.year, from: Date())
    }

    private func displayYearLabel() -> String {
        String(currentYear() + yearOffset)
    }

    func generateMonths(for year: Int) -> [Month] {
        let calendar = Calendar.current
        
        return (1...12).compactMap { month -> Month? in
            var comp = DateComponents()
            comp.year = year + yearOffset
            comp.month = month
            
            guard let date = calendar.date(from: comp) else { return nil }
            
            return Month(date: date, days: generateDays(for: date))
        }
    }

    private func generateDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }

        return range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: start)
        }
    }

    // MARK: - Helpers

    private func monthString(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "LLLL"
        return f.string(from: date)
    }

    private func firstWeekdayOffset(for date: Date) -> Int {
        let cal = Calendar.current
        guard let start = cal.date(from: cal.dateComponents([.year, .month], from: date)) else { return 0 }
        return cal.component(.weekday, from: start) - 1
    }

    private func backgroundColor(for date: Date) -> Color {
        if Calendar.current.isDateInToday(date) {
            return Color.green.opacity(0.6)
        } else if hasEvents(date) {
            return Color.blue.opacity(0.5)   // 📌 days WITH events
        } else if Calendar.current.isDateInWeekend(date) {
            return Color.red.opacity(0.12)
        } else {
            return Color.gray.opacity(0.08)  // 📌 normal days
        }
    }

    // MARK: - Scroll

    func scrollToCurrentMonth(proxy: ScrollViewProxy) {
        let now = Date()
        
        guard let month = months.first(where: {
            Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month)
        }) else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            proxy.scrollTo(month.id, anchor: .top)
        }
    }

    // MARK: - Events

    private func normalized(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    private func eventsBinding(for date: Date) -> Binding<[CalendarEvent]> {
        let key = normalized(date)
        
        return Binding(
            get: { eventsByDate[key] ?? [] },
            set: { eventsByDate[key] = $0 }
        )
    }

    private func addEvent(_ event: CalendarEvent, to date: Date) {
        let key = normalized(date)
        eventsByDate[key, default: []].append(event)
        
    }
    private func hasEvents(_ date: Date) -> Bool {
        let key = normalized(date)
        return !(eventsByDate[key]?.isEmpty ?? true)
    }
}

// MARK: - Day Detail

struct DayDetailView: View {
    let date: Date
    @Binding var events: [CalendarEvent]

    @Environment(\.dismiss) private var dismiss
    @State private var showAddEvent = false

    var body: some View {
        NavigationStack {
            
            List {
                if events.isEmpty {
                    Text("No events for this day.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(events) { event in
                        VStack(alignment: .leading) {
                            Text(event.title).bold()
                            Text(event.time)
                            Text(event.location)
                            Text(event.materials)
                        }
                    }
                }
            }
            
            // 👇 TOOLBAR GOES HERE (outside List, inside NavigationStack)
            .navigationTitle(formattedDate(date))
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddEvent = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            
            // 👇 SHEET ALSO HERE
            .sheet(isPresented: $showAddEvent) {
                AddEventView(initialDate: date) { newEvent, _ in
                    events.append(newEvent)
                }
            }
        }
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

// MARK: - Add Event

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var time = ""
    @State var location = ""
    @State var materials = ""
    @State var date: Date

    var onSave: (CalendarEvent, Date) -> Void

    init(initialDate: Date, onSave: @escaping (CalendarEvent, Date) -> Void) {
        self.onSave = onSave
        _date = State(initialValue: initialDate)
    }
    
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
                
                // CANCEL
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // SAVE ✅
                ToolbarItem(placement: .topBarTrailing) {
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

// MARK: - Preview

#Preview {
    CalendarView()
}
