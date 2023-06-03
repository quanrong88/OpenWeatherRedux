//
//  HomeView.swift
//  OpenWeatherAppRedux
//
//  Created by Tạ Minh Quân on 21/05/2023.
//

import SwiftUI
import OpenWeatherBusinessLogic
import Kingfisher

struct HomeView: View {
    @EnvironmentObject var store: Store<AppState>
    var state: HomeState? { store.state.screenState(for: .home) }
    
    var searchBar: some View {
        Text("")
            .searchable(
                text: Binding(get: { state?.searchText ?? "" }, set: { store.dispatch(HomeStateAction.updateSearchWord(word: $0)) }),
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .disableAutocorrection(true)
    }
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            searchBar
            HStack {
                VStack(alignment: .leading) {
                    if let name = state?.cityName {
                        Text(name)
                            .font(.largeTitle)
                    }
                    if let urlStr = state?.iconURL, let url = URL(string: urlStr)  {
                        KFImage(url)
                    }
                    if let temp = state?.temp, temp > 0 {
                        Text("Tempature: \(String(format: "%.2f", temp))°C")
                            .padding(5)
                    }
                    if let humidity = state?.humidity, humidity > 0 {
                        Text("Humidity: \(humidity)%")
                            .padding(5)
                    }
                    
                        
                    Spacer()
                }
                .offset(CGSize(width: 20, height: 0))
                Spacer()
                NavigationLink(
                    isActive: Binding(
                        get: {
                            return state?.isShowDetail ?? false
                        }, set: { isActive in
                            guard !isActive else { return }
                            store.dispatch(ActiveScreenStateAction.dismissScreen(.forecast))
                        })) {
                            ForecastView()
                        } label: {
                            
                        }
                        .hidden()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("OpenWeather")
        .background(.green)
        .toolbar {
            if let name = state?.cityName, !name.isEmpty {
                Button(
                    action: {
                        store.dispatch(ActiveScreenStateAction.showScreen(.forecast))
                    },
                    label: {
                        Text("Details")
                            .foregroundColor(.black)
                        Image(systemName: "chevron.right.2")
                            .foregroundColor(.black)
                    }
                )
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let mock = Store(
            initial: .mock,
            reducer: AppState.reducer,
            middlewares: []
        )
        NavigationView {
            HomeView().environmentObject(mock)
        }
    }
}
