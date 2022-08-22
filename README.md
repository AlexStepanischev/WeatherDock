## Weather Dock
### Weather forecast in MacOS menu bar
Weather Dock is a MacOS headless application that shows popover view under the menu bar with weather info. Application requests and uses user location data to provide weather forecast by coordinates. Also user could type any desired city name inline to get weather info for any city of his choise.
### Download
Application built with **SwiftUI**, requires **MacOS Monterey 12.0 or later**

[![](https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us?size=250x83&releaseDate=1615852800)](https://apps.apple.com/app/id1624480719)
### Screenshots
![Light mode screenshot](/docs/images/screen1.png "Light mode screenshot") ![Dark mode screenshot](/docs/images/screen2.png "Dark mode screenshot")
### Functionality
- Refresh icon is a button that refreshes current weather status
- Locate icon is a button that updates current and forecasted weather data by current user location and sets this behaviour as default
- City name is an inline editable text field, where user can submit (with enter hit) any city name and application will try to get and update weather info based on entered value. Application will remember city name for further updates, if user wants to switch back to updates by coordinates, he should click Locate icon button.
- Mouse over Air quality data will show popover with Pollutants info
- Mouse over future day forecast will show popover with forecast details for that day
- Right click on Menu item (dock) element will show Quit button to close app 
- Settings gear icon is a button that opens Setting view, following app settings are available:
    - Units of measurement: *imperial/metric*
    - Pressure unit: *inHG/mmHG/hPa*
    - Time format *12h/24h*
    - Settings for customization of menu bar button to display *temperature, short weather description, city name*
    - *Launch at login* setting
- Application updates data in a background, but update frequency is limited by [OpenWeatherAPI](https://openweathermap.org/api) free tier restrictions: 
    - Current weather data - every *1 hour*
    - Forecasted weather data - every *24 hours*
    - Also current weather data would be updated on popover open, but not more than once every *20 minutes*
    
### Third Parties
 - Application powered by [OpenWeatherAPI](https://openweathermap.org/api)
 - Launch at login setting added as a dependency on [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin) helper
 
### Changelog
 - For changelog please visit [Releases](https://github.com/AlexStepanischev/WeatherDock/releases) page
 
## How to build
Application build tested under **Xcode 13.3.1, 13.4**
- Clone repository and open project with Xcode
- Register [OpenWeatherAPI](https://openweathermap.org/api) free tier account and get your own API key
- Create **keys.plist** file under project folder and add 

    | Key | Type | Value |
    | ------------- |:-------------:|:-------------:|
    | openweather_api_key | String | {your API key} |
- Build, run and enjoy!

## Support
If you need a support or have any questions, feedback, bug reports or feature requests, please, contact via Telegram chat: https://t.me/weather_dock_app

[Privacy Policy](https://alexstepanischev.github.io/WeatherDock/)
