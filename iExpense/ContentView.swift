//
//  ContentView.swift
//  iExpense
//
//  Created by Alex McPherson on 04/08/2020.
//

import SwiftUI

struct SecondView: View {

    @Environment(\.presentationMode) var presentationMode
    var name: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, \(name)")
            Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ContentView: View {

    @State private var showingSheet = false

    var body: some View {
        Button("Show sheet") {
            self.showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "Alex")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
