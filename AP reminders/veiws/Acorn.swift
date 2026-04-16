import SwiftUI

// ============================================================
// MARK: - AP Course Data Model
// ============================================================

struct APCourse: Identifiable {
    let id = UUID()
    let name: String
    let subject: String          // e.g. "Math & CS", "Science", "History", etc.
    let description: String
    let prerequisites: String
    let examStats: APExamStats
}

struct APExamStats {
    let passRate: String         // % scoring 3 or higher
    let avgScore: String
    let totalTakers: String
    let difficulty: String       // "Moderate", "Hard", "Very Hard"
}

// ============================================================
// MARK: - AP Course List  ← ADD / REMOVE COURSES HERE
// ============================================================
// To ADD a course:  append a new APCourse(...) to the array below.
// To REMOVE a course: delete its APCourse(...) entry from the array.
// ============================================================

func allAPCourses() -> [APCourse] {
    return [

        // ── Math & Computer Science ──────────────────────────

        APCourse(
            name: "AP Calculus AB",
            subject: "Math & CS",
            description: "Covers limits, derivatives, and integrals. Equivalent to a first-semester college calculus course.",
            prerequisites: "Pre-Calculus or equivalent",
            examStats: APExamStats(passRate: "60%", avgScore: "2.96", totalTakers: "302,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Calculus BC",
            subject: "Math & CS",
            description: "Extends AB content with sequences, series, parametric and polar equations. Equivalent to two semesters of college calculus.",
            prerequisites: "AP Calculus AB or Pre-Calculus",
            examStats: APExamStats(passRate: "79%", avgScore: "3.61", totalTakers: "145,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP Statistics",
            subject: "Math & CS",
            description: "Introduces data collection, probability, statistical inference, and data analysis using real-world datasets.",
            prerequisites: "Algebra 2 or equivalent",
            examStats: APExamStats(passRate: "57%", avgScore: "2.87", totalTakers: "222,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Computer Science A",
            subject: "Math & CS",
            description: "Focuses on object-oriented programming in Java, algorithms, and data structures.",
            prerequisites: "Some programming experience helpful",
            examStats: APExamStats(passRate: "67%", avgScore: "3.16", totalTakers: "77,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Computer Science Principles",
            subject: "Math & CS",
            description: "Explores the big ideas of computer science: algorithms, data, the internet, and the impact of technology on society.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "70%", avgScore: "3.06", totalTakers: "134,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Precalculus",
            subject: "Math & CS",
            description: "Covers polynomial, rational, exponential, logarithmic, trigonometric, and polar functions to prepare for calculus.",
            prerequisites: "Algebra 2",
            examStats: APExamStats(passRate: "51%", avgScore: "2.71", totalTakers: "68,000+", difficulty: "Moderate")
        ),

        // ── Science ──────────────────────────────────────────

        APCourse(
            name: "AP Biology",
            subject: "Science",
            description: "Covers evolution, cellular processes, genetics, and ecology with a strong emphasis on lab work and scientific reasoning.",
            prerequisites: "Biology and Chemistry recommended",
            examStats: APExamStats(passRate: "65%", avgScore: "2.93", totalTakers: "260,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP Chemistry",
            subject: "Science",
            description: "Covers atomic structure, chemical bonding, thermodynamics, kinetics, and equilibrium with extensive lab work.",
            prerequisites: "Biology and Algebra 2 recommended",
            examStats: APExamStats(passRate: "53%", avgScore: "2.71", totalTakers: "160,000+", difficulty: "Very Hard")
        ),
        APCourse(
            name: "AP Physics 1",
            subject: "Science",
            description: "Algebra-based physics covering kinematics, forces, energy, waves, and electric charge.",
            prerequisites: "Algebra 2 (concurrent OK)",
            examStats: APExamStats(passRate: "43%", avgScore: "2.42", totalTakers: "170,000+", difficulty: "Very Hard")
        ),
        APCourse(
            name: "AP Physics 2",
            subject: "Science",
            description: "Algebra-based second course covering fluid mechanics, thermodynamics, electromagnetism, optics, and modern physics.",
            prerequisites: "AP Physics 1",
            examStats: APExamStats(passRate: "66%", avgScore: "3.02", totalTakers: "26,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP Physics C: Mechanics",
            subject: "Science",
            description: "Calculus-based mechanics covering kinematics, Newton's laws, work, energy, rotation, and oscillations.",
            prerequisites: "Calculus (concurrent OK)",
            examStats: APExamStats(passRate: "74%", avgScore: "3.42", totalTakers: "56,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP Physics C: Electricity & Magnetism",
            subject: "Science",
            description: "Calculus-based course covering electrostatics, conductors, capacitors, circuits, and magnetic fields.",
            prerequisites: "AP Physics C: Mechanics or concurrent",
            examStats: APExamStats(passRate: "71%", avgScore: "3.28", totalTakers: "30,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP Environmental Science",
            subject: "Science",
            description: "Interdisciplinary course covering Earth systems, ecosystems, energy resources, pollution, and global environmental issues.",
            prerequisites: "Biology and Chemistry recommended",
            examStats: APExamStats(passRate: "49%", avgScore: "2.69", totalTakers: "162,000+", difficulty: "Moderate")
        ),

        // ── History & Social Studies ─────────────────────────

        APCourse(
            name: "AP U.S. History",
            subject: "History & Social Studies",
            description: "Surveys U.S. history from pre-Columbian times to the present with emphasis on historical thinking skills.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "53%", avgScore: "2.71", totalTakers: "497,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP World History: Modern",
            subject: "History & Social Studies",
            description: "Examines world history from c. 1200 CE to the present, focusing on patterns of continuity and change.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "56%", avgScore: "2.79", totalTakers: "349,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP European History",
            subject: "History & Social Studies",
            description: "Covers European history from c. 1450 to the present, including the Renaissance through modern globalization.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "56%", avgScore: "2.81", totalTakers: "97,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP Government & Politics: U.S.",
            subject: "History & Social Studies",
            description: "Examines U.S. political systems, institutions, policy, and civil liberties with emphasis on required foundational documents.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "52%", avgScore: "2.65", totalTakers: "338,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Government & Politics: Comparative",
            subject: "History & Social Studies",
            description: "Compares political systems of six countries including the UK, China, Iran, Mexico, Nigeria, and Russia.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "60%", avgScore: "2.94", totalTakers: "25,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Human Geography",
            subject: "History & Social Studies",
            description: "Explores how humans shape and are shaped by the world's geographic patterns, places, and environments.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "55%", avgScore: "2.74", totalTakers: "237,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Psychology",
            subject: "History & Social Studies",
            description: "Introduces scientific study of behavior and mental processes including biological bases, cognition, development, and social influence.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "60%", avgScore: "2.89", totalTakers: "306,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Economics: Macro",
            subject: "History & Social Studies",
            description: "Covers national income, economic performance, financial markets, monetary and fiscal policy, and international trade.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "61%", avgScore: "2.91", totalTakers: "154,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Economics: Micro",
            subject: "History & Social Studies",
            description: "Covers supply and demand, consumer and producer theory, market structure, and the role of government in markets.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "65%", avgScore: "3.02", totalTakers: "83,000+", difficulty: "Moderate")
        ),

        // ── English ───────────────────────────────────────────

        APCourse(
            name: "AP English Language & Composition",
            subject: "English",
            description: "Develops skills in analyzing and producing nonfiction texts, with emphasis on rhetoric, argumentation, and synthesis.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "55%", avgScore: "2.79", totalTakers: "570,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP English Literature & Composition",
            subject: "English",
            description: "Focuses on the close reading and critical analysis of literary texts — fiction, poetry, and drama.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "49%", avgScore: "2.62", totalTakers: "390,000+", difficulty: "Hard")
        ),

        // ── World Languages ───────────────────────────────────

        APCourse(
            name: "AP Spanish Language & Culture",
            subject: "World Languages",
            description: "Develops proficiency in Spanish across interpersonal, interpretive, and presentational communication modes.",
            prerequisites: "Spanish 3 or equivalent",
            examStats: APExamStats(passRate: "87%", avgScore: "3.72", totalTakers: "178,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Spanish Literature & Culture",
            subject: "World Languages",
            description: "Engages students with literary texts from Spain, Latin America, and U.S. Latino writers across multiple centuries.",
            prerequisites: "AP Spanish Language or equivalent",
            examStats: APExamStats(passRate: "72%", avgScore: "3.21", totalTakers: "24,000+", difficulty: "Hard")
        ),
        APCourse(
            name: "AP French Language & Culture",
            subject: "World Languages",
            description: "Develops proficiency in French across all communication modes within cultural contexts.",
            prerequisites: "French 3 or equivalent",
            examStats: APExamStats(passRate: "80%", avgScore: "3.49", totalTakers: "22,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Chinese Language & Culture",
            subject: "World Languages",
            description: "Focuses on interpersonal, interpretive, and presentational Chinese communication in cultural contexts.",
            prerequisites: "Chinese 3 or equivalent",
            examStats: APExamStats(passRate: "94%", avgScore: "4.30", totalTakers: "19,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Japanese Language & Culture",
            subject: "World Languages",
            description: "Develops proficiency in Japanese across all communication modes using authentic cultural materials.",
            prerequisites: "Japanese 3 or equivalent",
            examStats: APExamStats(passRate: "92%", avgScore: "4.16", totalTakers: "3,900+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP German Language & Culture",
            subject: "World Languages",
            description: "Develops proficiency in German with an emphasis on authentic cultural and real-world contexts.",
            prerequisites: "German 3 or equivalent",
            examStats: APExamStats(passRate: "83%", avgScore: "3.60", totalTakers: "5,400+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Italian Language & Culture",
            subject: "World Languages",
            description: "Develops proficiency in Italian across interpersonal, interpretive, and presentational modes.",
            prerequisites: "Italian 3 or equivalent",
            examStats: APExamStats(passRate: "83%", avgScore: "3.58", totalTakers: "2,200+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Latin",
            subject: "World Languages",
            description: "Focuses on reading Caesar's Gallic Wars and Vergil's Aeneid in the original Latin.",
            prerequisites: "Latin 3 or equivalent",
            examStats: APExamStats(passRate: "69%", avgScore: "3.13", totalTakers: "5,700+", difficulty: "Hard")
        ),

        // ── Arts ──────────────────────────────────────────────

        APCourse(
            name: "AP Art History",
            subject: "Arts",
            description: "Examines global artistic traditions from prehistory to the present, developing visual analysis and contextual understanding.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "62%", avgScore: "2.97", totalTakers: "23,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Music Theory",
            subject: "Arts",
            description: "Covers the fundamentals of music theory including notation, ear training, harmony, and composition.",
            prerequisites: "Ability to read music recommended",
            examStats: APExamStats(passRate: "60%", avgScore: "3.02", totalTakers: "17,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Studio Art: 2-D Design",
            subject: "Arts",
            description: "Portfolio-based course exploring design principles through drawing, painting, printmaking, and collage.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "84%", avgScore: "3.51", totalTakers: "24,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Studio Art: 3-D Design",
            subject: "Arts",
            description: "Portfolio-based course exploring three-dimensional design through sculpture, architecture, ceramics, and installation.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "89%", avgScore: "3.74", totalTakers: "5,400+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Studio Art: Drawing",
            subject: "Arts",
            description: "Portfolio-based course emphasizing mark-making, line, and compositional skills across various drawing media.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "86%", avgScore: "3.62", totalTakers: "14,000+", difficulty: "Moderate")
        ),

        // ── Other ─────────────────────────────────────────────

        APCourse(
            name: "AP Seminar",
            subject: "Other",
            description: "Part of the AP Capstone program. Students investigate real-world topics through research, collaboration, and presentation.",
            prerequisites: "None",
            examStats: APExamStats(passRate: "81%", avgScore: "3.39", totalTakers: "55,000+", difficulty: "Moderate")
        ),
        APCourse(
            name: "AP Research",
            subject: "Other",
            description: "Part of the AP Capstone program. Students design, plan, and conduct a year-long research project on a topic of their choice.",
            prerequisites: "AP Seminar",
            examStats: APExamStats(passRate: "83%", avgScore: "3.46", totalTakers: "16,000+", difficulty: "Moderate")
        ),

    ]
}

// ============================================================
// MARK: - Acorn View
// ============================================================

struct Acorn: View {

    @State private var searchText = ""
    @State private var expandedCourseID: UUID?
    @State private var expandedStatsID: UUID?

    private let courses = allAPCourses()

    private var grouped: [(subject: String, courses: [APCourse])] {
        let subjects = ["Math & CS", "Science", "History & Social Studies",
                        "English", "World Languages", "Arts", "Other"]
        return subjects.compactMap { subject in
            let filtered = filteredCourses.filter { $0.subject == subject }
            return filtered.isEmpty ? nil : (subject: subject, courses: filtered)
        }
    }

    private var filteredCourses: [APCourse] {
        if searchText.isEmpty { return courses }
        return courses.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.subject.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {

                // ── Links Section ────────────────────────────
                Section {
                    linkRow(
                        title: "College Board",
                        subtitle: "AP courses, scores & registration",
                        icon: "graduationcap.fill",
                        color: .blue,
                        url: "https://apstudents.collegeboard.org"
                    )
                    linkRow(
                        title: "Bluebook™ App",
                        subtitle: "Digital testing platform",
                        icon: "book.closed.fill",
                        color: .indigo,
                        url: "https://bluebook.app.collegeboard.org"
                    )
                } header: {
                    Text("Quick Links")
                }

                // ── Tutorial Section ─────────────────────────
                Section {
                    Button {
                        openURL("https://www.youtube.com/watch?v=uGCUBSBgUGI")
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Bluebook Tutorial")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text("How to set up and use the testing app")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Tutorial")
                }

                // ── AP Courses Section ───────────────────────
                Section {
                    ForEach(grouped, id: \.subject) { group in
                        subjectHeader(group.subject)
                        ForEach(group.courses) { course in
                            courseRow(course)
                        }
                    }
                } header: {
                    Text("AP Courses (\(filteredCourses.count))")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("AP Center")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search AP courses")
        }
    }

    // ── Subviews ─────────────────────────────────────────────

    @ViewBuilder
    private func linkRow(title: String, subtitle: String, icon: String, color: Color, url: String) -> some View {
        Button { openURL(url) } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private func subjectHeader(_ subject: String) -> some View {
        HStack {
            Text(subject.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Spacer()
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 2, trailing: 16))
    }

    @ViewBuilder
    private func courseRow(_ course: APCourse) -> some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Tap row ──────────────────────────────────────
            Button {
                withAnimation(.easeInOut(duration: 0.22)) {
                    expandedCourseID = expandedCourseID == course.id ? nil : course.id
                    if expandedCourseID != course.id { expandedStatsID = nil }
                }
            } label: {
                HStack {
                    Text(course.name)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: expandedCourseID == course.id ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)

            // ── Info Dropdown ─────────────────────────────────
            if expandedCourseID == course.id {
                VStack(alignment: .leading, spacing: 10) {
                    Divider().padding(.vertical, 4)

                    Label("About", systemImage: "info.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(course.description)
                        .font(.subheadline)

                    Label("Prerequisites", systemImage: "checkmark.seal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(course.prerequisites)
                        .font(.subheadline)

                    // ── Stats sub-dropdown ────────────────────
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            expandedStatsID = expandedStatsID == course.id ? nil : course.id
                        }
                    } label: {
                        HStack {
                            Label("Exam Stats", systemImage: "chart.bar.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: expandedStatsID == course.id ? "chevron.up" : "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(.plain)

                    if expandedStatsID == course.id {
                        statsGrid(course.examStats)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.bottom, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    @ViewBuilder
    private func statsGrid(_ stats: APExamStats) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            statCard(label: "Pass Rate (3+)", value: stats.passRate, icon: "percent", color: .green)
            statCard(label: "Avg Score", value: stats.avgScore + " / 5", icon: "star.fill", color: .yellow)
            statCard(label: "Test Takers", value: stats.totalTakers, icon: "person.3.fill", color: .blue)
            statCard(label: "Difficulty", value: stats.difficulty, icon: "flame.fill",
                     color: stats.difficulty == "Very Hard" ? .red : stats.difficulty == "Hard" ? .orange : .teal)
        }
        .padding(.top, 4)
    }

    @ViewBuilder
    private func statCard(label: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.08))
        .cornerRadius(10)
    }

    // ── URL helper ────────────────────────────────────────────

    private func openURL(_ string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }
}

// ============================================================
// MARK: - Preview
// ============================================================

