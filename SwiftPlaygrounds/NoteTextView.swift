import SwiftUI
import UIKit

struct NoteTextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = UIColor.label
        textView.backgroundColor = UIColor.clear
        textView.keyboardType = .default
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .yes
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = false
        
        // Configurar placeholder si está vacío
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.placeholderText
        } else {
            textView.text = text
            textView.textColor = UIColor.label
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Solo actualizar si el texto cambió externamente
        if uiView.text != text {
            if text.isEmpty {
                uiView.text = placeholder
                uiView.textColor = UIColor.placeholderText
            } else {
                uiView.text = text
                uiView.textColor = UIColor.label
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: NoteTextView
        
        init(_ parent: NoteTextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Limpiar placeholder al enfocar
            if textView.text == parent.placeholder && textView.textColor == UIColor.placeholderText {
                textView.text = ""
                textView.textColor = UIColor.label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            // Mostrar placeholder si queda vacío
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.placeholderText
            } else {
                parent.text = textView.text
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

