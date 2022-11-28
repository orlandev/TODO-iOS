//
//  ContentView.swift
//  TODO
//
//  Created by Orlando on 11/27/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var allTodos : [TodoItem] = []
    private let todosKey="todosKey"
    
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                    TextField("Add TODO",text:$newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        guard !self.newTodo.isEmpty else { return }
                        self.allTodos.append(TodoItem(todo: self.newTodo))
                        self.newTodo=""
                        self.saveTodos()
                    } label: {
                       Image(systemName: "plus")
                    }
                    .padding(.leading,5)

                }.padding()
                
                List {
                    ForEach(self.allTodos){ todoItem in
                        Text(todoItem.todo)
                    }
                    .onDelete(perform: deleteTodo)
                }
                
            }
            .navigationBarTitle("TODO")
            
        }
        .onAppear(perform: loadTodos)
        
        
    }
    
    private func deleteTodo(at offset:IndexSet){
        self.allTodos.remove(atOffsets: offset)
        saveTodos()
    }
    
    private func saveTodos(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: todosKey)
    }
    
    
    private func loadTodos(){
        if let todosData=UserDefaults.standard.value(forKey: todosKey) as? Data{
            
            if let todoList=try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData){
                
                self.allTodos=todoList
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct TodoItem:Codable,Identifiable {
    var id = UUID()
    let todo : String
}
