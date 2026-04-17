// ============================================================
// ContentView.swift
// AP Reminders
//
// Root view. Hosts the tab bar and injects AppState as an
// EnvironmentObject so every child tab can read/write shared
// state without passing it manually.
//
// ACCESSIBILITY FIXES:
//   • Dark mode is applied via .preferredColorScheme and
//     re-evaluated on every render — no init() side effects
//     that caused crashes.
//   • Large text uses @ScaledMetric-friendly .dynamicTypeSize
//     modifier so system font scaling still works; the toggle
//     bumps it one extra step (accessibility2) when on.
//   • High contrast tints the environment with a higher-
//     contrast color scheme hint.
//   • Tab bar appearance is rebuilt in a helper that is called
//     from .onAppear and .onChange so it tracks dark mode live.
// ============================================================

import SwiftUI

struct ContentView: View {

    // ── Accessibility settings (persisted) ───────────────────
    @AppStorage("darkMode")     private var darkMode      = false
    @AppStorage("highContrast") private var highContrast  = false
    @AppStorage("largeText")    private var largeText     = false

    // ── Shared app state ──────────────────────────────────────
    @StateObject private var appState = AppState()

    var body: some View {
        TabView {
            // ── Messages tab ──────────────────────────────────
            Messages()
                .tabItem {
                    Label("Messages", systemImage: "envelope.fill")
                }

            // ── AP Center (Acorn) tab ─────────────────────────
            Acorn()
                .tabItem {
                    Label("AP Center", systemImage: "book")
                }

            // ── Settings tab ──────────────────────────────────
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

            // ── Calendar tab ──────────────────────────────────
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
        // Inject shared state into the entire view hierarchy
        .environmentObject(appState)

        // ── Dark mode ─────────────────────────────────────────
        // Using .preferredColorScheme here (not in init) prevents
        // the crash caused by mutating @AppStorage inside init().
        .preferredColorScheme(darkMode ? .dark : .light)

        // ── Large text ────────────────────────────────────────
        // When enabled, bump dynamic type one accessibility step.
        .dynamicTypeSize(largeText ? .accessibility2 : .large)

        // ── High contrast ─────────────────────────────────────
        // Tells the system to prefer a higher-contrast rendering.
       // .environment(\.colorSchemeContrast, highContrast ? .increased : .standard)
        
        
        
        
        
        
        
        
        
        
        // fix ^^^^^^

        // ── Tab bar appearance ────────────────────────────────
        .onAppear        { applyTabBarAppearance() }
        .onChange(of: darkMode) { applyTabBarAppearance() }
    }

    // ── Tab bar styling ───────────────────────────────────────
    // Called on appear and whenever darkMode changes so the bar
    // colour tracks the current scheme without a restart.
    private func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // systemGray adapts automatically to light/dark mode
        appearance.backgroundColor = UIColor.systemGray5
        UITabBar.appearance().standardAppearance   = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
