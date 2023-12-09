//
//  AddProduct.swift
//  SwipeTask
//
//  Created by Dhruv Shrivastava on 07/12/23.
//

import SwiftUI
import PhotosUI

struct AddProduct: View {
    @State var productName : String = ""
    @State var productType : String = ""
    @State var price : String = ""
    @State var tax : String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @ObservedObject var viewModel = ViewModel.shared
    @Environment(\.presentationMode) var mode
    @State var disble = true
    var body: some View {
        ScrollView {
            TextField("Product Name", text: $productName)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing])
            TextField("Product Type", text: $productType)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing])
            TextField("Price", text: $price)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing])
                .keyboardType(.numberPad)
            TextField("Tax", text: $tax)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing])
                .keyboardType(.numberPad)
            Text("Add the photo of the product")
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Image(systemName: "plus.rectangle.on.rectangle")
                        .padding()
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .onAppear {
                        disble = false
                    }
            }
            Button {
                viewModel.createProduct(productName: productName, productType: productType, price: price, tax: tax, imageData: selectedImageData!)
            } label: {
                Text("Add Product")
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 50)
                    .background(.green)
                    .cornerRadius(10)
            }
            .disabled(disble)
            
            if viewModel.isLoading {
                ProgressView()
                    .onDisappear {
                        mode.wrappedValue.dismiss()
                    }
            }
            Spacer()
            
            
        }
        
    }
}

#Preview {
    AddProduct()
}
