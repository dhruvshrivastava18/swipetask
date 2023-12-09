//
//  ContentView.swift
//  SwipeTask
//
//  Created by Dhruv Shrivastava on 07/12/23.
//

import SwiftUI
import Kingfisher
struct ContentView: View {
    @State var searchText = ""
    @ObservedObject var viewModel = ViewModel.shared
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.filteredArray, id: \.productName) {
                                product in
                                ProductElementView(image: KFImage(URL(string: product.image)), productName: product.productName, productType: product.productType, price: String(product.price), tax: String(product.tax))
                                   
                            }
                            
                    }
                    .searchable(text: $searchText, prompt: "Find a Product")
                    .onChange(of: searchText) { oldValue, newValue in
                        viewModel.search(query: newValue)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
                NavigationLink {
                    AddProduct()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing)
                }
            })
            .onAppear {
                viewModel.getProduct()
            }
            .navigationTitle("Products")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                    
                
            }
        }
    }
}

#Preview {
    ContentView()
}
