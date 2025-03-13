import SwiftUI

struct OnboardingView: View {
    @State private var currentForm: FormType = .none
    @StateObject var controller = LoginController()
    @EnvironmentObject var authManager: AuthenticationManager

    enum FormType {
        case none, login, register
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: 0xB5CFE3)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        if currentForm != .none {
                            Button(action: { self.currentForm = .none }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color(hex: 0x4C708A))
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 25)

                    Spacer()

                    Image("VLogo")
                        .resizable()
                        .frame(width: 250, height: 250)

                    Spacer()

                    VStack(spacing: 16) {
                        if currentForm == .login {
                            VStack {
                                HStack(spacing: 10) {
                                    Spacer()
                                    TextField(
                                        "Username",
                                        text: $controller.username
                                    )
                                    .textFieldStyle(TriangleTextFieldStyle())
                                    Spacer()
                                }

                                HStack(spacing: 10) {
                                    Spacer()
                                    SecureField(
                                        "Password",
                                        text: $controller.password
                                    )
                                    .textFieldStyle(TriangleTextFieldStyle())
                                    Spacer()
                                }

                                if let errorMessage = controller
                                    .errorMessage
                                {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(Color.white.opacity(0.3))
                                        .cornerRadius(60)
                                        .transition(.opacity)
                                }

                                HStack(spacing: 10) {
                                    Spacer()
                                    Button(action: controller.login) {
                                        ZStack {
                                            if controller.isLoading {
                                                ProgressView()
                                                    .scaleEffect(1.5)
                                            } else {
                                                Text("Sign in")
                                                    .frame(maxWidth: .infinity)
                                                    .cornerRadius(10)
                                                    .contentShape(Rectangle())
                                            }
                                        }
                                    }
                                    .animation(
                                        .easeInOut(duration: 0.3),
                                        value: controller.isLoading
                                    )
                                    .buttonStyle(TrianglePrimaryButton())
                                    .disabled(controller.isLoading)
                                    Spacer()
                                }
                            }
                            .navigationDestination(
                                isPresented: $controller.navigateToDashboard
                            ) {
                                ContentView()
                                    .environmentObject(NavbarVisibility())
                            }
                        } else if currentForm == .register {
                            RegisterForm()
                        } else {
                            VStack(spacing: 30) {
                                HStack(spacing: 300) {
                                    Spacer()
                                    Button(action: {
                                        withAnimation { currentForm = .login }
                                    }) {
                                        Text("Sign in")
                                            .frame(maxWidth: .infinity)
                                            .cornerRadius(10)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(TrianglePrimaryButton())
                                    Spacer()
                                }

                                VStack {
                                    LabelledDivider(
                                        label: "or", horizontalPadding: 20,
                                        color: Color.white
                                    )
                                    .frame(height: 1)
                                }
                                .padding(.horizontal, 400)

                                HStack(spacing: 300) {
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            currentForm = .register
                                        }
                                    }) {
                                        Text("Create an account")
                                            .frame(maxWidth: .infinity)
                                            .cornerRadius(10)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(TriangleSecondaryButton())
                                    Spacer()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .animation(.easeInOut, value: currentForm)
            }
        }
        .onAppear {
            controller.authManager = authManager
        }
    }

}

struct LoginForm: View {
    @StateObject var controller = LoginController()

    var body: some View {
        VStack(spacing: 16) {
            if let errorMessage = controller.errorMessage {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(60)
                    .frame(maxWidth: .infinity)
                    .transition(.opacity)
            }

            HStack(spacing: 10) {
                Spacer()
                TextField("Username", text: $controller.username)
                    .textFieldStyle(TriangleTextFieldStyle())
                Spacer()
            }

            HStack(spacing: 10) {
                Spacer()
                SecureField("Password", text: $controller.password)
                    .textFieldStyle(TriangleTextFieldStyle())
                Spacer()
            }

            HStack(spacing: 10) {
                Spacer()
                Button(action: controller.login) {
                    ZStack {
                        if controller.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                        } else {
                            Text("Sign in")
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .animation(
                    .easeInOut(duration: 0.3), value: controller.isLoading
                )
                .buttonStyle(TrianglePrimaryButton())
                .disabled(controller.isLoading)
                Spacer()
            }
        }
        .padding()
    }
}

// ✅ Register Form
struct RegisterForm: View {
    @StateObject var controller = RegisterController()

    var body: some View {
        VStack(spacing: 16) {
            if let errorMessage = controller.errorMessage {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(60)
                    .frame(maxWidth: .infinity)
                    .transition(.opacity)
            }

            HStack(spacing: 10) {
                Spacer()
                TextField("Username", text: $controller.username)
                    .textFieldStyle(TriangleTextFieldStyle())
                Spacer()
            }

            HStack(spacing: 10) {
                Spacer()
                TextField("Email", text: $controller.email)
                    .textFieldStyle(TriangleTextFieldStyle())
                Spacer()
            }

            HStack(spacing: 10) {
                Spacer()
                SecureField("Password", text: $controller.password)
                    .textFieldStyle(TriangleTextFieldStyle())
                Spacer()
            }

            HStack(spacing: 10) {
                Spacer()
                SecureField(
                    "Confirm Password", text: $controller.confirmPassword
                )
                .textFieldStyle(TriangleTextFieldStyle())
                Spacer()
            }

            HStack(spacing: 10) {
                Spacer()
                Button(action: controller.register) {
                    ZStack {
                        if controller.isLoading {
                            ProgressView()
                        } else {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .animation(
                    .easeInOut(duration: 0.3), value: controller.isLoading
                )
                .buttonStyle(TrianglePrimaryButton())
                .disabled(controller.isLoading)
                Spacer()
            }
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(
        label: String, horizontalPadding: CGFloat = 8,
        color: Color = Color(UIColor.separator)
    ) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            line
            Text(label)
                .font(.callout)
                .foregroundColor(color)
                .lineLimit(1)
                .fixedSize()
                .offset(y: -1)
            line
        }
    }

    var line: some View {
        VStack { Divider().frame(height: 1).background(color) }.padding(
            horizontalPadding)
    }
}
