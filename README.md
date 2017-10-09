# Yelp Clone

**Yelp Clone** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

## Features
- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).
- [x] Search results page
   - [x] Infinite scroll for restaurant results.
   - [x] Implement map view of restaurant results.
- [x] Implemented the restaurant detail page.

## Video Walkthrough
<img src='http://i.imgur.com/N59Thr8.gif' title='ListViewController' width='' alt='ListViewController' /> <img src='http://i.imgur.com/NMooJ3V.gif' title='MapViewController' width='' alt='MapViewController' /> <img src='http://i.imgur.com/KI12of9.gif' title='MapViewController' width='' alt='MapViewController' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

    Copyright 2017 Ali Mir

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
