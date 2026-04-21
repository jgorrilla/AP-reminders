// ============================================================
// TeacherLoginView.swift
// AP Reminders
//
// Sheet presented from Settings when "Enable Teacher Mode" is
// tapped. Validates email against an allowlist and checks a
// shared password. On success calls onComplete(true), which
// Settings uses to set AppState.isTeacherMode = true.
//
// TO ADD AN AUTHORIZED EMAIL: add it to allowedEmails below.
// TO CHANGE THE PASSWORD:     update sharedPassword below.
// ============================================================

import SwiftUI

struct TeacherLoginView: View {

    // ── Auth config ───────────────────────────────────────────
    // Add teacher email addresses to this set.
    let allowedEmails: Set<String> = [
        "64005533@ep-student.org",
        "teacher2@school.org",
        "test",
    ]

    // Shared password for all teacher accounts.
    let sharedPassword = "1234"

    // ── State ─────────────────────────────────────────────────
    @Environment(\.dismiss) private var dismiss
    @State private var email        = ""
    @State private var password     = ""
    @State private var errorMessage : String?

    /// Called with true on successful login, false is never called
    /// (the sheet is simply dismissed on cancel).
    var onComplete: (Bool) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Verify Teacher Access")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    SecureField("Password", text: $password)
                }

                if let errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Teacher Login")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Verify") { validate() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Validation

    private func validate() {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespaces)

        guard allowedEmails.contains(normalizedEmail) else {
            errorMessage = "Email not authorized."
            return
        }
        guard password == sharedPassword else {
            errorMessage = "Incorrect password."
            return
        }

        onComplete(true)
        dismiss()
    }
}
