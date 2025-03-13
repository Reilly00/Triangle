import SwiftUI

struct BodyLanguageRecognitionView: View {
    @Environment(\.presentationMode) var presentationMode
    let onComplete: () -> Void
    @StateObject var controller: BodyLanguageRecognitionController

    init(targetBodyLanguage: BodyLanguage? = nil, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        _controller = StateObject(wrappedValue: BodyLanguageRecognitionController(targetBodyLanguage: targetBodyLanguage))
    }
    
    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Which body language best matches '\(controller.targetBodyLanguage.rawValue)'?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .padding(.bottom, 15)
                
                HStack(spacing: 30) {
                    ForEach(controller.availableBodyLanguages, id: \.self) { bodyLanguage in
                        Button(action: {
                            controller.checkAnswer(
                                selected: bodyLanguage,
                                onComplete: onComplete,
                                dismiss: { presentationMode.wrappedValue.dismiss() }
                            )
                        }) {
                            Image(bodyLanguage.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding()
                                .background(
                                    controller.selectedBodyLanguage == bodyLanguage
                                        ? (controller.isCorrect == true ? Color(hex: 0x58D68D) : Color(hex: 0xEC7063))
                                        : Color(hex: 0x96B6CF)
                                )
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding(.top, 30)
            }
        }
    }
}

struct BodyLanguageRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        BodyLanguageRecognitionView(onComplete: {
            print("Exercise complete!")
        })
    }
}
