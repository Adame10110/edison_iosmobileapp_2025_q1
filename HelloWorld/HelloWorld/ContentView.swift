//
//  ContentView.swift
//  HelloWorld
//
//  Created by Adam Eisert on 3/4/25.
//

import SwiftUI


struct ContentView: View {

    @StateObject private var viewModel = ToDoListViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Input task", text: $viewModel.inputTask)
                Button("Add") {
                    viewModel.addItem()
                }
            }
            .padding([.leading, .trailing, .bottom], 15)
            .background(Color.gray.opacity(0.2))
            
            List {
                ForEach(viewModel.toDoItems) { item in
                    HStack {
                        Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                viewModel.toggleItem(item)
                            }
                        if viewModel.editingItemId == item.id {
                            TextField("", text: Binding(
                                get: { item.title },
                                set: { newValue in
                                    viewModel.updateItemText(item, newValue)
                                }
                            ))
                            .onSubmit {
                                viewModel.onSubmit()
                            }
                            
                        } else {
                                Text(item.title)
                                .strikethrough(item.isComplete)
                                .onTapGesture {
                                    viewModel.onSubmit(item)
                                }
                        }
                        Spacer()
                        Button {
                            viewModel.removeItem(item)
                        } label : {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                    }
                }
            }
            
            
            Spacer()
        }
        .onAppear() {
            viewModel.loadData()
        }
    }
}

#Preview {
    ContentView()
}
