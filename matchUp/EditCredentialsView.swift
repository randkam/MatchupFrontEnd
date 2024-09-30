import SwiftUI
import UIKit  // Added UIKit for UIImage

struct EditCredentialsView: View {
    @Binding var userName: String
    @Binding var userNickName: String
    @State private var newPassword = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Credentials")) {
                    TextField("Username", text: $userName)
                    TextField("Nickname", text: $userNickName)
                    SecureField("New Password", text: $newPassword)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Save Changes") {
                    saveChanges()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("Edit Profile")
        }
    }

    private func saveChanges() {
        // Ensure userId and email are present from UserDefaults
        guard let email = UserDefaults.standard.string(forKey: "loggedInUserEmail"),
              let userId = UserDefaults.standard.string(forKey: "loggedInUserId") else {
            errorMessage = "No email or user ID found. Please log in again."
            return
        }

        let networkManager = NetworkManager()
        networkManager.updateUserProfile(userId: userId, userName: userName, userNickName: userNickName, email: email) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Profile updated successfully.")
                    presentationMode.wrappedValue.dismiss()
                } else {
                    print("Failed to update profile: \(error?.localizedDescription ?? "Unknown error")")
                    errorMessage = "Failed to update profile. Please try again."
                }
            }
        }
    }
}
