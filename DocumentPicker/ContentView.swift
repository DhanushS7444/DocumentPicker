//
//  ContentView.swift
//  DocumentPicker
//
//  Created by Dhanush on 28/01/20.
//  Copyright © 2020 Dhanush. All rights reserved.
//

import SwiftUI
import MobileCoreServices
import Firebase

struct ContentView: View {
    @State var show = false
    @State var alert = false
    var body: some View {
        Button(action : {
            self.show.toggle()
        }){
            Text("Document Picker")
        }
        .sheet(isPresented: $show){
            DocumentPicker(alert: self.$alert)
        }
        .alert(isPresented: $alert){
            Alert(title: Text("Message"), message: Text("Uploaded Successfully"), dismissButton: .default(Text("Ok")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DocumentPicker : UIViewControllerRepresentable {
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    @Binding var alert : Bool
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        // we can change that String(KUTTypeItem / PDF / MP3) based on which document You want to pick
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject,UIDocumentPickerDelegate {
        var parent : DocumentPicker
        init (parent1 : DocumentPicker){
            parent = parent1
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let bucket = Storage.storage().reference()
            bucket.child((urls.first?.deletingPathExtension().lastPathComponent)!).putFile(from: urls.first!, metadata: nil) { (_, err) in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                print("Success")
                self.parent.alert.toggle()
                
            }
        }
    }
}

// after that check in firebase for the document u are uploaded in the App in Storage section of firebase
