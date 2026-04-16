import SwiftUI

struct TeacherLoginView: View {
    let allowedEmails: Set<String> = [
        "teacher1@school.org",
        "teacher2@school.org",
        "admin@school.org"
    ]

    let sharedPassword = "AP2026" // change to whatever you want
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var onComplete: (Bool) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("Verify Teacher Access")) {
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                    
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Teacher Login")
            
            .toolbar {
                
                // Cancel
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                // Submit
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Verify") {
                        validate()
                    }
                }
            }
        }
    }
    
    func validate() {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespaces)
        
        // 🔹 Check email is allowed
        guard allowedEmails.contains(normalizedEmail) else {
            errorMessage = "Email not authorized"
            return
        }
        
        // 🔹 Check password matches shared password
        guard password == sharedPassword else {
            errorMessage = "Incorrect password"
            return
        }
        
        // 🔹 Success
        onComplete(true)
        dismiss()
    }
}
