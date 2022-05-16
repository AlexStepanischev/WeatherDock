## Weather Dock
Application build with **SwiftUI**, tested on **MacOS Monterey 12.3.1**
### Weather forecast in MacOS menu bar
Weather Dock is a MacOS headless application that shows popover view under the menu bar with weather info. Application requests and uses user location data to provide weather forecast by coordinates. Also user could type any desired city name inline to get weather info for any city of his choise.
### Functionality
- Refresh icon is a button that refreshes current weather status
- Locate icon is a button that updates current and forecasted weather data by current user location and sets this behaviour as default
- City name is an inline editable text field, where user can submit (with enter hit) any city name and application will try to get and update weather info based on entered value. Application will remember city name for further updates, if user wants to switch back to updates by coordinates, he should click Locate icon button.
- Settings gear icon is a button that opens Setting view, following app settings are available:
    - Units of measurement: *imperial/metric*
    - Pressure unit: *inHG/mmHG/hPa*
    - Time format *12h/24h*
- Application updates data in a background, but update frequency is limited by [OpenWeatherAPI](https://openweathermap.org/api) free tier restrictions: 
    - Current weather data - every *1 hour*
    - Foretasted weather data - every *24 hours*
    - Also current weather data would be updated on popover open, but not more than once every *20 minutes*
    
### Third Parties
 - Application powered by [OpenWeatherAPI](https://openweathermap.org/api)
 
## How to build
Application build tested under **Xcode 13.3.1**
- Clone repository and open project with Xcode
- Register [OpenWeatherAPI](https://openweathermap.org/api) free tier account and get your own API key
- Create **keys.plist** file under project folder and add 

    | Key | Type | Value |
    | ------------- |:-------------:|:-------------:|
    | openweather_api_key | String | {your API key} |
- Build, run and enjoy!

## Support
If you need a support or have any questions, feedback, bug reports or feature requests, please, contact via Telegram chat: https://t.me/weather_dock_app
