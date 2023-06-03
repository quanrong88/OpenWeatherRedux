//
//  ForecastItemView.swift
//  OpenWeatherAppRedux
//
//  Created by Tạ Minh Quân on 27/05/2023.
//

import SwiftUI
import OpenWeatherBusinessLogic
import Kingfisher

struct ForecastItemView: View {
    let cellModel: ForecastCellModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: cellModel.displayIcon) {
                    KFImage(url)
                        .frame(width: 60.0, height: 60.0)
                        .padding([.leading, .trailing], 20)
                    VStack(alignment: .leading) {
                        Text(cellModel.displayTempature)
                        Text(cellModel.displayHumidity)
                    }
                    Spacer()
                }
               
            }
            Text(cellModel.displayDateTime)
                .font(.caption)
                .padding(.leading, 20)
                
        }
        
    }
}

struct ForecastItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForecastItemView(cellModel: .mock)
    }
}
