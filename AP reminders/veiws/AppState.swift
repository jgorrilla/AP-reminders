//
//  AppState.swift
//  AP reminders
//
//  Created by 64005533 on 4/17/26.
//

// ============================================================
// AppState.swift
// AP Reminders
//
// PURPOSE:
//   Single source of truth shared across all tabs via
//   @EnvironmentObject. Holds:
//     • Teacher mode flag
//     • The student's enrolled AP classes
//     • Messages sent by teachers to classes
//     • Class-wide calendar events added by teachers
//     • Personal calendar events added by students
//
// HOW TO USE:
//   In AP_remindersApp.swift (or wherever your @main App is),
//   create one instance and inject it:
//
//     @StateObject private var appState = AppState()
//     ContentView().environmentObject(appState)
//
//   Then in any View read/write it with:
//     @EnvironmentObject var appState: AppState
// ============================================================

import SwiftUI
import Combine

// MARK: - Shared Message Model

/// A message sent by a teacher to a specific AP class.
struct ClassMessage: Identifiable, Hashable {
    let id = UUID()
    let className: String       // e.g. "AP Biology"
    let subject: String
    let body: String
    let sentAt: Date
}

// MARK: - Shared Calendar Event Model

/// A calendar event that belongs either to a specific class
/// (teacher-posted) or to the individual student (personal).
struct AppCalendarEvent: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var time: String
    var location: String
    var materials: String
    /// nil = personal event; non-nil = class event for that AP course name
    var className: String?
}

// MARK: - AppState

class AppState: ObservableObject {

    // ── Teacher mode ──────────────────────────────────────────
    /// Persisted across launches via @AppStorage-compatible UserDefaults write.
    @Published var isTeacherMode: Bool {
        didSet { UserDefaults.standard.set(isTeacherMode, forKey: "teacherMode") }
    }

    // ── Student enrolled classes ──────────────────────────────
    /// The set of AP course names this student has subscribed to.
    @Published var enrolledClasses: Set<String> {
        didSet {
            if let data = try? JSONEncoder().encode(Array(enrolledClasses)) {
                UserDefaults.standard.set(data, forKey: "enrolledClasses")
            }
        }
    }

    // ── Messages ──────────────────────────────────────────────
    /// All class messages. Students only see messages for their enrolled classes.
    @Published var messages: [ClassMessage] = []

    // ── Events (keyed by normalized date) ────────────────────
    /// Personal events: only visible to the current user.
    @Published var personalEventsByDate: [Date: [AppCalendarEvent]] = [:]

    /// Class events: posted by teachers, visible to enrolled students.
    @Published var classEventsByDate: [Date: [AppCalendarEvent]] = [:]

    // MARK: - Init

    init() {
        // Restore teacher mode
        isTeacherMode = UserDefaults.standard.bool(forKey: "teacherMode")

        // Restore enrolled classes
        if let data = UserDefaults.standard.data(forKey: "enrolledClasses"),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            enrolledClasses = Set(decoded)
        } else {
            enrolledClasses = []
        }
    }

    // MARK: - Enrollment helpers

    func enroll(in className: String) {
        enrolledClasses.insert(className)
    }

    func unenroll(from className: String) {
        enrolledClasses.remove(className)
    }

    func isEnrolled(in className: String) -> Bool {
        enrolledClasses.contains(className)
    }

    // MARK: - Message helpers

    /// Teacher sends a message to a class.
    func sendMessage(to className: String, subject: String, body: String) {
        let msg = ClassMessage(className: className, subject: subject, body: body, sentAt: Date())
        messages.insert(msg, at: 0)
    }

    /// Returns messages the current user can see.
    /// Teachers see all; students only see messages for enrolled classes.
    func visibleMessages() -> [ClassMessage] {
        if isTeacherMode { return messages }
        return messages.filter { enrolledClasses.contains($0.className) }
    }

    // MARK: - Calendar helpers

    func normalizedDate(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    /// Add a personal event (student only).
    func addPersonalEvent(_ event: AppCalendarEvent, to date: Date) {
        let key = normalizedDate(date)
        personalEventsByDate[key, default: []].append(event)
    }

    /// Add a class-wide event (teacher only).
    func addClassEvent(_ event: AppCalendarEvent, to date: Date) {
        let key = normalizedDate(date)
        classEventsByDate[key, default: []].append(event)
    }

    /// All events visible to the current user on a given date.
    /// Students see their personal events + class events for enrolled classes.
    /// Teachers see all class events + their own personal events.
    func visibleEvents(on date: Date) -> [AppCalendarEvent] {
        let key = normalizedDate(date)
        let personal = personalEventsByDate[key] ?? []
        let classEvts = (classEventsByDate[key] ?? []).filter { evt in
            guard let cn = evt.className else { return true }
            return isTeacherMode || enrolledClasses.contains(cn)
        }
        return personal + classEvts
    }

    /// Returns true if there are any visible events on a date (for calendar dot).
    func hasVisibleEvents(on date: Date) -> Bool {
        !visibleEvents(on: date).isEmpty
    }
}
