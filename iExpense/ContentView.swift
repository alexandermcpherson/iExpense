//
//  ContentView.swift
//  iExpense
//
//  Created by Alex McPherson on 04/08/2020.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(items) {
                UserDefaults.standard.set(data, forKey: "Items")
            }
        }
    }

    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = data
                return
            }
        }
        self.items = []
    }

    func removeItems(of offSets: IndexSet) {
        items.remove(atOffsets: offSets)
    }

    func styleExpense(amount: Int) -> Color {
        var color: Color = .black
        if amount <= 10 {
            color = .green
        } else if amount > 10 && amount < 100 {
            color = .blue
        } else if amount >= 100 {
            color = .red
        }
        return color
    }
}

struct ContentView: View {

    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(expenses.styleExpense(amount: item.amount))
                    }
                }
                .onDelete(perform: expenses.removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
