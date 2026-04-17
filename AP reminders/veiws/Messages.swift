// ============================================================
// Messages.swift
// AP Reminders
//
// Displays class messages for the current user.
//
// STUDENT VIEW:
//   Shows only messages for classes the student has enrolled in
//   (via the AP Center tab). If no classes are enrolled, prompts
//   the student to add classes first.
//
// TEACHER VIEW:
//   Shows all sent messages. A compose button (top-right) opens
//   SendMessageView where the teacher picks a class, writes a
//   subject + body, and sends.
//
// DATA FLOW:
//   All messages live in AppState.messages (in-memory for now).
//   AppState.visibleMessages() handles the filtering logic.
// ============================================================

import SwiftUI

// MARK: - Messages Tab

struct Messages: View {

    @EnvironmentObject var appState: AppState
    @State private var showCompose = false
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        NavigationStack {
            Group {
                let visible = appState.visibleMessages()

                if visible.isEmpty {
                    emptyState
                } else {
                    List(visible) { message in
                        MessageCardView(message: message)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Messages")
            .toolbar {
                // Teachers get a compose button
                if appState.isTeacherMode {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showCompose = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showCompose) {
                SendMessageView()
                    .environmentObject(appState)
                    .preferredColorScheme(darkMode ? .dark : .light)
            }
        }
    }

    // ── Empty state ───────────────────────────────────────────

    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: appState.isTeacherMode ? "tray" : "envelope.badge")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(appState.isTeacherMode
                 ? "No messages sent yet."
                 : "No messages yet.")
                .font(.headline)

            if !appState.isTeacherMode {
                Text("Add AP classes in the AP Center tab to receive updates from your teachers.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Message Card

struct MessageCardView: View {
    let message: ClassMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                // Class badge
                Text(message.className)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())

                Spacer()

                Text(message.sentAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(message.subject)
                .font(.headline)

            Text(message.body)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Send Message View (Teacher only)

/// Presented as a sheet when a teacher taps the compose button.
/// Teacher picks a target class from their enrolled-class list
/// (all AP courses), writes subject + body, and sends.
struct SendMessageView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedClass = ""
    @State private var subject = ""
    @State private var boody   = ""
    @State private var showValidationError = false

    // All AP course names — used to populate the class picker.
    // This mirrors the list in Acorn.swift; if you add a course
    // there, add it here too (or refactor to a shared constant).
    private let allCourseNames: [String] = {
        fallbackCourseNames()
    }()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Class", selection: $selectedClass) {
                        Text("Select a class…").tag("")
                        ForEach(allCourseNames, id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Send To")
                }

                Section {
                    TextField("Subject", text: $subject)
                    TextEditor(text: $boody)
                        .frame(minHeight: 120)
                } header: {
                    Text("Message")
                }

                if showValidationError {
                    Section {
                        Label("Please fill in all fields and select a class.", systemImage: "exclamationmark.triangle")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Send") { send() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func send() {
        guard !selectedClass.isEmpty, !subject.isEmpty, !boody.isEmpty else {
            showValidationError = true
            return
        }
        appState.sendMessage(to: selectedClass, subject: subject, body: boody)
        dismiss()
    }
}

// ============================================================
// MARK: - Course name list for the class picker
// ============================================================
// This returns just the names (not full APCourse objects) so
// SendMessageView doesn't need to import the whole course model.
// Keep in sync with allAPCourses() in Acorn.swift.
// ============================================================

private func fallbackCourseNames() -> [String] {
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
