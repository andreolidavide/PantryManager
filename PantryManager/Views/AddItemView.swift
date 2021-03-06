//
//  AddItemView.swift
//  PantryManager
//
//  Created by Davide Andreoli on 14/04/21.
//

import SwiftUI
import Combine

struct AddItemView: View {
    // State variables
    @State var itemStorage: FoodStorage
    @State private var newItemName = ""
    @State private var newItemExpiryDate = Date()
    @State private var newItemQuantity: Double = 1
    // Others
    let numberFormatter = NumberFormatter.defaultFormatter
    // View Model
    @ObservedObject var viewModel: PantryManagerViewModel
    //Environment variables
    @Environment(\.managedObjectContext) private var database
    @Environment(\.presentationMode) var presentationMode
    // Fetch request to fetch all storages
    @FetchRequest var storages: FetchedResults<FoodStorage>
    
    //Custom initializer, necessary to initialize the storages request
    init(itemStorage: FoodStorage, viewModel: PantryManagerViewModel) {
        _itemStorage = State(wrappedValue: itemStorage)
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _storages = FetchRequest(fetchRequest: FoodStorage.fetchRequest(.all))
    }
//    MARK: UI/UX - Is it better to delete the sections?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Storage")) {

                    Picker(selection: $itemStorage, label: Text("Storage")) {
                        ForEach(storages.sorted(), id:\.self) { storage in
                            Text(storage.name)
                        }
                    }
                }
                Section(header: Text("Name")) {
                    TextField("Item name", text: $newItemName)
                }
                Section(header: Text("Quantity")) {
                    DoubleField("Item quantity", value: $newItemQuantity, formatter: numberFormatter)
                }
                Section(header: Text("Expiry Date")) {
                    DatePicker("Expiry Date", selection: $newItemExpiryDate, displayedComponents: [.date])
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addItem(name: newItemName, expiryDate: newItemExpiryDate, quantity: newItemQuantity, storage: itemStorage, in: database)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add")
                    }
                    .disabled(newItemName.isEmpty || newItemQuantity == 0)
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        let foodStorage = FoodStorage(name: "Storage")
        AddItemView(itemStorage: foodStorage, viewModel: PantryManagerViewModel())
    }
}

