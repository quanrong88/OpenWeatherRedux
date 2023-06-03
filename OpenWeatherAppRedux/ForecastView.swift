//
//  ForecastView.swift
//  OpenWeatherAppRedux
//
//  Created by Tạ Minh Quân on 27/05/2023.
//

import SwiftUI
import OpenWeatherBusinessLogic

struct ForecastView: View {
    @EnvironmentObject var store: Store<AppState>
    var state: ForecastState? { store.state.screenState(for: .forecast) }
    
    var body: some View {
        
        ZStack {
            Color.green.ignoresSafeArea()
            if let models = state?.forecasts {
                List(models) { model in
                    ForecastItemView(cellModel: model)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.green)
                }
                .listStyle(PlainListStyle())
                .listRowBackground(Color.green)
                .background(.green)
            } else {
                Text("No data")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Forecasts")
        .onLoad {
            store.dispatch(ForecastStateAction.loadData)
        }
        .ignoresSafeArea()
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = Store(
            initial: .mock,
            reducer: AppState.reducer,
            middlewares: []
        )
        ForecastView().environmentObject(mock)
    }
}
