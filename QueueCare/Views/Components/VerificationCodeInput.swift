import SwiftUI

struct VerificationCodeInput: View {
    @Binding var code: String
    @FocusState.Binding var focusedIndex: Int?
    let index: Int
    let brandColor: Color

    var body: some View {
        TextField("", text: Binding(
            get: {
                guard code.count > index else { return "" }
                let startIndex = code.index(code.startIndex, offsetBy: index)
                let endIndex = code.index(after: startIndex)
                return String(code[startIndex..<endIndex])
            },
            set: { newValue in
                let filtered = newValue.filter { $0.isNumber }
                guard let char = filtered.last else {
                    if code.count > index {
                        let startIndex = code.index(code.startIndex, offsetBy: index)
                        let endIndex = code.index(after: startIndex)
                        code.removeSubrange(startIndex..<endIndex)
                    }
                    return
                }
                
                if code.count > index {
                    let startIndex = code.index(code.startIndex, offsetBy: index)
                    let endIndex = code.index(after: startIndex)
                    code.replaceSubrange(startIndex..<endIndex, with: String(char))
                } else if code.count == index {
                    code.append(char)
                }
                
                if code.count > index {
                    focusedIndex = min(index + 1, 4)
                }
            }
        ))
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        .multilineTextAlignment(.center)
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .frame(width: 54, height: 54)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedIndex == index ? brandColor : Color.gray.opacity(0.3), lineWidth: focusedIndex == index ? 2 : 1)
        )
        .focused($focusedIndex, equals: index)
    }
}

#Preview {
    @Previewable @State var code = ""
    @Previewable @FocusState var focusedIndex: Int?
    
    HStack(spacing: 12) {
        ForEach(0..<5) { index in
            VerificationCodeInput(
                code: $code,
                focusedIndex: $focusedIndex,
                index: index,
                brandColor: Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
            )
        }
    }
    .padding()
    .background(Color(red: 0.94, green: 0.97, blue: 0.97))
}
