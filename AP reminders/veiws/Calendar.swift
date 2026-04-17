// ============================================================
// Calendar.swift
// AP Reminders
//
// Full-year scrollable calendar with per-day event detail.
//
// EVENT MODES:
//   TEACHER: Adding an event shows a class picker. The event
//            is posted to AppState.classEventsByDate and becomes
//            visible to all students enrolled in that class.
//
//   STUDENT: Adding an event saves it to
//            AppState.personalEventsByDate — private to them.
//            They also see class events for their enrolled classes.
//
// DATA FLOW:
//   All reads/writes go through AppState so the Messages tab
//   and Calendar tab stay in sync without passing data manually.
// ============================================================

import SwiftUI

// MARK: - Legacy thin wrapper (keeps old CalendarEvent name alive)
// AppCalendarEvent (in AppState.swift) is the canonical model.
// This typealias lets any remaining references compile cleanly.
typealias CalendarEvent = AppCalendarEvent

// MARK: - Supporting models

struct Month: Identifiable, Equatable {
    let id   = UUID()
    let date : Date
    let days : [Date]
}

struct SelectedDate: Identifiable {
    let id   = UUID()
    let date : Date
}

// MARK: - Main Calendar View

struct CalendarView: View {

    @EnvironmentObject var appState: AppState
    @AppStorage("darkMode") private var darkMode = false

    @State private var months    : [Month]       = []
    @State private var yearOffset: Int           = 0
    @State private var selectedDate: SelectedDate?
    @State private var showAddEvent = false
    @State private var addEventDate = Date()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        VStack(spacing: 0) {

            // ── Year header ───────────────────────────────────
            HStack {
                Button { shiftYear(by: -1) } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(displayYearLabel())
                    .font(.title2).bold()
                Spacer()
                Button { shiftYear(by: 1) } label: {
                    Image(systemName: "chevron.right")
                }
                // Add-event button
                Button {
                    addEventDate = selectedDate?.date ?? Date()
                    showAddEvent = true
                } label: {
                    Image(systemName: "plus")
                        .padding(.leading, 12)
                }
            }
            .padding()

            Divider()

            // ── Scrollable months ─────────────────────────────
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 28) {
                        ForEach(months) { month in
                            monthView(month).id(month.id)
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
        // Add-event sheet — teacher sees class picker, student sees personal form
        .sheet(isPresented: $showAddEvent) {
            AddEventView(initialDate: addEventDate)
                .environmentObject(appState)
                .preferredColorScheme(darkMode ? .dark : .light)
        }
        // Day-detail sheet
        .sheet(item: $selectedDate) { selection in
            DayDetailView(date: selection.date)
                .environmentObject(appState)
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }

    // MARK: - Month view

    private func monthView(_ month: Month) -> some View {
        VStack(spacing: 12) {
            Text(monthString(from: month.date))
                .font(.title2).bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                ForEach(weekdaySymbols(), id: \.self) { day in
                    Text(day)
                        .font(.caption).foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 10) {
                // Blank leading cells
                ForEach(0..<firstWeekdayOffset(for: month.date), id: \.self) { _ in
                    Color.clear.frame(height: 44)
                }
                // Day cells
                ForEach(month.days, id: \.self) { date in
                    Button {
                        selectedDate = SelectedDate(date: date)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(backgroundColor(for: date))
                                .frame(height: 44)
                            Text("\(Calendar.current.component(.day, from: date))")
                                .foregroundColor(
                                    Calendar.current.isDateInWeekend(date) ? .red : .primary
                                )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers

    private func weekdaySymbols() -> [String] {
        let cal   = Calendar.current
        let syms  = cal.shortWeekdaySymbols
        let start = cal.firstWeekday - 1
        return Array(syms[start...]) + Array(syms[..<start])
    }

    private func loadMonths()  { months = generateMonths(for: currentYear()) }
    private func currentYear() -> Int { Calendar.current.component(.year, from: Date()) }
    private func displayYearLabel() -> String { String(currentYear() + yearOffset) }

    private func shiftYear(by value: Int) {
        yearOffset += value
        loadMonths()
    }

    private func generateMonths(for year: Int) -> [Month] {
        (1...12).compactMap { month -> Month? in
            var comp = DateComponents()
            comp.year  = year + yearOffset
            comp.month = month
            guard let date = Calendar.current.date(from: comp) else { return nil }
            return Month(date: date, days: generateDays(for: date))
        }
    }

    private func generateDays(for date: Date) -> [Date] {
        let cal = Calendar.current
        guard let range = cal.range(of: .day, in: .month, for: date),
              let start = cal.date(from: cal.dateComponents([.year, .month], from: date))
        else { return [] }
        return range.compactMap { cal.date(byAdding: .day, value: $0 - 1, to: start) }
    }

    private func monthString(from date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "LLLL"; return f.string(from: date)
    }

    private func firstWeekdayOffset(for date: Date) -> Int {
        let cal = Calendar.current
        guard let start = cal.date(from: cal.dateComponents([.year, .month], from: date)) else { return 0 }
        return cal.component(.weekday, from: start) - 1
    }

    private func backgroundColor(for date: Date) -> Color {
        if Calendar.current.isDateInToday(date)          { return Color.green.opacity(0.6) }
        if appState.hasVisibleEvents(on: date)           { return Color.blue.opacity(0.5)  }
        if Calendar.current.isDateInWeekend(date)        { return Color.red.opacity(0.12)  }
        return Color.gray.opacity(0.08)
    }

    private func scrollToCurrentMonth(proxy: ScrollViewProxy) {
        let now = Date()
        guard let month = months.first(where: {
            Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month)
        }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            proxy.scrollTo(month.id, anchor: .top)
        }
    }
}

// MARK: - Day Detail View

/// Shows all visible events for a single day.
/// Students see their personal events + enrolled-class events.
/// Teachers see all class events + their own personal events.
struct DayDetailView: View {

    let date: Date
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @AppStorage("darkMode") private var darkMode = false
    @State private var showAddEvent = false

    var body: some View {
        NavigationStack {
            List {
                let events = appState.visibleEvents(on: date)

                if events.isEmpty {
                    Text("No events for this day.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(events) { event in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(event.title).bold()
                                Spacer()
                                // Badge showing class name or "Personal"
                                Text(event.className ?? "Personal")
                                    .font(.caption2)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(
                                        (event.className != nil ? Color.blue : Color.gray).opacity(0.15)
                                    )
                                    .foregroundColor(event.className != nil ? .blue : .secondary)
                                    .clipShape(Capsule())
                            }
                            if !event.time.isEmpty      { Text(event.time).font(.subheadline) }
                            if !event.location.isEmpty  { Text(event.location).font(.subheadline) }
                            if !event.materials.isEmpty { Text(event.materials).font(.subheadline) }
                        }
                    }
                }
            }
            .navigationTitle(formattedDate(date))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddEvent = true } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventView(initialDate: date)
                    .environmentObject(appState)
                    .preferredColorScheme(darkMode ? .dark : .light)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .full; return f.string(from: date)
    }
}

// MARK: - Add Event View

/// For students: saves a personal event.
/// For teachers: shows a class picker and saves a class-wide event.
struct AddEventView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var title     = ""
    @State private var time      = ""
    @State private var location  = ""
    @State private var materials = ""
    @State private var date      : Date
    /// Teacher-only: which class this event is for
    @State private var selectedClass = ""
    @State private var showValidation = false

    // All AP course names for the teacher class picker
    private let allCourseNames: [String] = fallbackCourseNamesForCalendar()

    init(initialDate: Date) {
        _date = State(initialValue: initialDate)
    }

    var body: some View {
        NavigationStack {
            Form {
                // ── Event details ─────────────────────────────
                Section {
                    TextField("Title", text: $title)
                    TextField("Time (e.g. 9:00 AM)", text: $time)
                    TextField("Location", text: $location)
                    TextField("Materials needed", text: $materials)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                } header: {
                    Text("Event Details")
                }

                // ── Teacher: class selector ───────────────────
                if appState.isTeacherMode {
                    Section {
                        Picker("Class", selection: $selectedClass) {
                            Text("Select a class…").tag("")
                            ForEach(allCourseNames, id: \.self) { name in
                                Text(name).tag(name)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } header: {
                        Text("Post To Class")
                    } footer: {
                        Text("This event will be visible to all students enrolled in the selected class.")
                    }
                }

                // ── Validation error ──────────────────────────
                if showValidation {
                    Section {
                        Label(
                            appState.isTeacherMode
                                ? "Please fill in a title and select a class."
                                : "Please fill in a title.",
                            systemImage: "exclamationmark.triangle"
                        )
                        .foregroundColor(.red)
                        .font(.caption)
                    }
                }
            }
            .navigationTitle(appState.isTeacherMode ? "Add Class Event" : "Add Personal Event")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }.fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        guard !title.isEmpty else { showValidation = true; return }
        if appState.isTeacherMode && selectedClass.isEmpty { showValidation = true; return }

        let event = AppCalendarEvent(
            title: title,
            time: time,
            location: location,
            materials: materials,
            className: appState.isTeacherMode ? selectedClass : nil
        )

        if appState.isTeacherMode {
            appState.addClassEvent(event, to: date)
        } else {
            appState.addPersonalEvent(event, to: date)
        }
        dismiss()
    }
}

// ── Course name list for the class picker ─────────────────────
// Mirrors the list in Messages.swift. Keep both in sync.
private func fallbackCourseNamesForCalendar() -> [String] {
    [
        "AP Calculus AB", "AP Calculus BC", "AP Statistics",
        "AP Computer Science A", "AP Computer Science Principles", "AP Precalculus",
        "AP Biology", "AP Chemistry", "AP Physics 1", "AP Physics 2",
        "AP Physics C: Mechanics", "AP Physics C: Electricity & Magnetism",
        "AP Environmental Science",
        "AP U.S. History", "AP World History: Modern", "AP European History",
        "AP Government & Politics: U.S.", "AP Government & Politics: Comparative",
        "AP Human Geography", "AP Psychology",
        "AP Economics: Macro", "AP Economics: Micro",
        "AP English Language & Composition", "AP English Literature & Composition",
        "AP Spanish Language & Culture", "AP Spanish Literature & Culture",
        "AP French Language & Culture", "AP Chinese Language & Culture",
        "AP Japanese Language & Culture", "AP German Language & Culture",
        "AP Italian Language & Culture", "AP Latin",
        "AP Art History", "AP Music Theory",
        "AP Studio Art: 2-D Design", "AP Studio Art: 3-D Design", "AP Studio Art: Drawing",
        "AP Seminar", "AP Research",
    ]
}

// MARK: - Preview

#Preview { CalendarView() }
