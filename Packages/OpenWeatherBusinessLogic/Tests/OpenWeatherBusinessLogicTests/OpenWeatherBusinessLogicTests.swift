import XCTest
@testable import OpenWeatherBusinessLogic

final class OpenWeatherBusinessLogicTests: XCTestCase {
    let store = Store(
        initial: AppState(),
        reducer: AppState.reducer,
        middlewares: [ Middlewares.logger, Middlewares.openWeather]
    )
    
    func testSearchKeyWordInHome() throws {
        store.dispatch(ActiveScreenStateAction.showScreen(.forecast))
        
        store.dispatch(ActiveScreenStateAction.dismissScreen(.forecast))
        
        store.dispatch(HomeStateAction.updateSearchWord(word: "hanoi"))
        let exp = expectation(description: "Load API")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5)
        {
            if let homeScreen = self.store.state.activeScreens.screens.first as? AppScreenState  {
                if case .home(let state) = homeScreen {
                    XCTAssertTrue(!state.isLoading)
                }
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testLoadForecast() {
        store.dispatch(HomeStateAction.updateSearchWord(word: "hanoi"))
        store.dispatch(ActiveScreenStateAction.showScreen(.forecast))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            self.store.dispatch(ForecastStateAction.loadData)
        }
        
        let exp = expectation(description: "Load API")
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.5)
        {
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
}
