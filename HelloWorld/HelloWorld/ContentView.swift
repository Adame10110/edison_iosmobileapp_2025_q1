//
//  ContentView.swift
//  HelloWorld
//
//  Created by Adam Eisert on 3/4/25.
//

import SwiftUI

enum Priority: String, CaseIterable, Identifiable {
    case Urgent, Soon, Whenever
    var id: Self { self }
}

class killMe {
    
}

struct ContentView: View {

    @StateObject private var viewModel = ToDoListViewModel()
    
    @State private var sort = false
    @State private var hide = false
    @State private var searchText: String = ""
    @State private var priority: Priority = .Soon
    @State private var tag: String = ""
    @State var priorityToPass = 0
    var x = 0
    //priority
    //tags
    
    var body: some View {
        VStack {
            HStack {
                TextField("Input task", text: $viewModel.inputTask)
                Button("Add") {
                    viewModel.addItem($priority.wrappedValue, $tag.wrappedValue)
                }
            }
            VStack {
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases) { priority in Text(priority.rawValue.capitalized)
                    }
                }
            }
            .pickerStyle(.segmented)
            
            HStack {
                TextField("Tag", text: $tag)
            }
            
            HStack {
                TextField("Search Tasks", text: $searchText)
            }
            
            .padding([.leading, .trailing, .bottom], 15)
            .background(Color.gray.opacity(0.2))
            
            HStack {
                Toggle(isOn: $sort) {
                    Text("Sort Priority")
                }
                Toggle(isOn: $hide) {
                    Text("Hide Completed")
                }
            }
            
            .padding([.leading, .trailing, .bottom], 5)
            .background(Color.gray.opacity(0.2))
            
            if(hide)
            {
                List {
                    ForEach(viewModel.toDoItems) { item in
                        HStack {
                            if item.isComplete == false {
                                if item.title.lowercased().contains(searchText.lowercased())
                                    && searchText != "" || searchText == ""{
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
                                    
                                    Text(item.itemTag)
                                    
                                    //priority set
                                    if(item.itemPriority == 0)
                                    {
                                        Text("XXX")
                                    }
                                    if(item.itemPriority == 1)
                                    {
                                        Text("XX")
                                        
                                    }
                                    if(item.itemPriority == 2)
                                    {
                                        Text("X")
                                    }
                                    
                                    
                                    Button {
                                        viewModel.removeItem(item)
                                    } label : {
                                        Image(systemName: "minus.circle")
                                    }
                                    .buttonStyle(BorderlessButtonStyle())                         }
                    
                            }
                        }
                    }
                }
            }
            
            else
            {
                List {
                    ForEach(viewModel.toDoItems) { item in
                        HStack {
                            if item.title.lowercased().contains(searchText.lowercased())
                                && searchText != "" || searchText == ""{
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
                                
                                Text(item.itemTag)
                                
                                //priority set
                                if(item.itemPriority == 0)
                                {
                                    Text("XXX")
                                }
                                if(item.itemPriority == 1)
                                {
                                    Text("XX")
                                    
                                }
                                if(item.itemPriority == 2)
                                {
                                    Text("X")
                                }
                                
                                
                                Button {
                                    viewModel.removeItem(item)
                                } label : {
                                    Image(systemName: "minus.circle")
                                }
                                .buttonStyle(BorderlessButtonStyle())                            }
                        }
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
