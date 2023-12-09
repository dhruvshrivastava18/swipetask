//
//  ProductElementView.swift
//  SwipeTask
//
//  Created by Dhruv Shrivastava on 07/12/23.
//

import SwiftUI
import Kingfisher

struct ProductElementView: View {
    let image: KFImage
    let productName : String
    let productType : String
    let price : String
    let tax : String
    var body: some View {
        HStack {
            image
                .placeholder {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 90, height: 60)
                }
                .resizable()
                .frame(width: 90, height: 60)
                .cornerRadius(10)
                
            
            VStack(alignment: .leading) {
                Text("Product Name : \(productName)")
                Text("Product Type : \(productType)")
                Text("Price : \(price)")
                Text("Tax : \(tax)")
            }
            .padding(.leading)
        }
    }
}

#Preview {
    ProductElementView(image: KFImage(URL(string: "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1701708518_0_IMG-20231201-WA0007.jpg")), productName: "Demo", productType: "Demo", price: "Demo", tax: "Demo")
}
