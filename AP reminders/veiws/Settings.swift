// ============================================================
// Settings.swift
// AP Reminders
//
// Settings tab. Reads/writes:
//   • AppState.isTeacherMode  — toggled here, used across the app
//   • @AppStorage keys for accessibility prefs read by ContentView
//
// TEACHER MODE:
//   Logging in sets AppState.isTeacherMode = true.
//   A "Log Out of Teacher Mode" button appears when active,
//   setting it back to false and clearing the UserDefaults flag.
//
// ACCESSIBILITY:
//   Toggles write to @AppStorage; ContentView reads them and
//   applies .preferredColorScheme, .dynamicTypeSize, and
//   .environment(\.colorSchemeContrast) to the whole app.
//   The Settings sheet inherits the current color scheme so
//   it doesn't flash to light mode when presented.
// ============================================================

import SwiftUI

struct SettingsView: View {

    // ── Shared state ──────────────────────────────────────────
    @EnvironmentObject var appState: AppState

    // ── Accessibility (read by ContentView to apply app-wide) ─
    @AppStorage("darkMode")     private var darkMode     = false
    @AppStorage("highContrast") private var highContrast = false
    @AppStorage("largeText")    private var largeText    = false
    @AppStorage("useSymbols")   private var useSymbols   = false
    @AppStorage("language")     private var language     = "English"

    @State private var showTeacherLogin = false

    let languages = ["English", "Spanish", "French"]

    var body: some View {
        NavigationStack {
            Form {

                // ── Account section ───────────────────────────
                Section {
                    if appState.isTeacherMode {
                        // Show who is logged in + a log-out button
                        HStack {
                            Image(systemName: "person.badge.checkmark")
                                .foregroundColor(.green)
                            Text("Teacher Mode Active")
                                .foregroundColor(.primary)
                        }

                        Button(role: .destructive) {
                            appState.isTeacherMode = false
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out of Teacher Mode")
                            }
                        }
                    } else {
                        Button {
                            showTeacherLogin = true
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.key")
                                Text("Enable Teacher Mode")
                            }
                            .foregroundColor(.primary)
                        }
                    }
                } header: {
                    Text("Account")
                } footer: {
                    if appState.isTeacherMode {
                        Text("Teacher mode lets you send messages to classes and add class-wide calendar events.")
                    }
                }

                // ── Accessibility section ─────────────────────
                // Each toggle writes to @AppStorage.
                // ContentView observes those keys and applies the
                // corresponding modifiers to the whole app.
                Section {
                    Toggle("Dark Mode", isOn: $darkMode)

                    Toggle("High Contrast", isOn: $highContrast)

                    Toggle("Larger Text", isOn: $largeText)

                    Toggle("Use Symbols Instead of Color", isOn: $useSymbols)

                    Picker("Language", selection: $language) {
                        ForEach(languages, id: \.self) { Text($0) }
                    }
                } header: {
                    Text("Accessibility")
                }

                // ── App info section ──────────────────────────
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0").foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            // Sheet inherits current color scheme — no flash to light mode
            .sheet(isPresented: $showTeacherLogin) {
                TeacherLoginView { success in
                    if success { appState.isTeacherMode = true }
                }
                .preferredColorScheme(darkMode ? .dark : .light)
            }
        }
    }
}
