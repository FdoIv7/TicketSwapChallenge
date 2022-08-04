# TicketSwapChallenge

A mini Spotify app. This app allows the user to visualize New Album Releases from Spotify as well as searching for their favorite Artists getting the top songs and all albums released by that artist.
The app uses the Spotify API

# App Requirements

- XCode
- iOS Simulator
- Cocoapods

# Setup
- Clone the repository by using `git clone https://github.com/FdoIv7/TicketSwapChallenge.git` in Terminal
- Run `pod install`
- Open `TicketSwapChallenge.xcworkspace` file in Xcode
- Wait for the dependencies to be installed
- Run the app

# Dependencies

Dependencies were added by using both Swift Package Manager and Cocoapods. The TicketSwap Challenge App uses the next third party libraries: 
- SDWebImage
- RxSwift
- RxCocoa

# Architecture 

The project was built using MVVM Architecture, SOLID Principles and clean architecture. MVVM was chosen for the way it decouples all different layers of the app, leaving the whole business logic to the viewModels, successfuly separating UI, Data and ViewModels.
