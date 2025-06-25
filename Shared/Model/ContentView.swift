//
//  ContentView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 8/6/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var items: [DataItem]
    
    var body: some View {
        //        VStack{
        //
        //
        //            Text("Add Dara")
        //            Button("Add item"){
        //                addItem()
        //            }
        //            List{
        //                ForEach (items) { item in
        //
        //                    HStack{
        //                        Text(item.name)
        //                        Spacer()
        //                        Button {
        //                            updateItem(item)
        //                        } label: {
        //                            Image(systemName: "pencil")
        //                        }
        //
        //                    }
        //                }
        //                .onDelete{ indexes in
        //                    for index in indexes {
        //                        deleteItem(items[index])
        //
        //                    }
        //
        //                }
        //            }
        //            }
        //            .padding()
        //
        //        }
        //    func addItem(){
        //        let item = DataItem(name: "New Item")
        //            context.insert(item)
        //        print("hehe hi")
        //    }
        //    func deleteItem(_ item: DataItem) {
        //        context.delete(item)
        //    }
        //    func updateItem(_ item: DataItem){
        //        item.name = "Updated Item"
        //        try? context.save()
        //    }
        //
        //}
        
        Group{
            
            
            Register()
//            Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
      .environmentObject(StreamViewModel())
        
    }
}

