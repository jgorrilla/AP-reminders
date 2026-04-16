import SwiftUI

struct SettingsView: View {
    
    @AppStorage("teacherMode") private var teacherModeEnabled = false
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("highContrast") private var highContrast = false
    @AppStorage("largeText") private var largeText = false
    @AppStorage("useSymbols") private var useSymbols = false
    @AppStorage("language") private var language = "English"
    
    @State private var showTeacherLogin = false
    
    let languages = ["English", "Spanish", "French"]

    var body: some View {
        NavigationStack {
            Form {
                
                // Teacher Mode
                Section {
                    Button {
                        showTeacherLogin = true
                    } label: {
                        HStack {
                            Image(systemName: "person.badge.key")
                            Text(teacherModeEnabled ? "Teacher Mode Enabled" : "Enable Teacher Mode")
                        }
                        .foregroundColor(.primary) // ✅ Visible in both light & dark mode
                    }
                } header: {
                    Text("Account")
                }
                
                // Accessibility
                Section {
                    Toggle("Dark Mode", isOn: $darkMode)
                    Toggle("High Contrast", isOn: $highContrast)
                    Toggle("Larger Text", isOn: $largeText)
                    Toggle("Use Symbols Instead of Color", isOn: $useSymbols)
                    
                    Picker("Language", selection: $language) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang)
                        }
                    }
                } header: {
                    Text("Accessibility")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showTeacherLogin) {
                TeacherLoginView { success in
                    if success {
                        teacherModeEnabled = true
                    }
                }
                .preferredColorScheme(darkMode ? .dark : .light) // ✅ Sheet respects dark mode
            }
        }
    }
}
