# *IMDB Movies Demo*

**IMDB Demo** is an IMDB lient that fetches json from the IMDB public APIs and displays the result in a list layout using UIKit.

Time spent: **8** hours spent in total

## User Stories

App has the following features

- [x] Search for a movie
- [x] View list of movies fetched from the IMDB API using the specified search string
- [x] Tap on a movie in the list to view the movie fetched item in a detail screen

## Tech Stack
- [x] UIKit, layout done using Autolayout with stackviews used where possible.
- [x] Use of MVVM to structure and organize the app into Single Responsibility modules.
- [x] Use of Actors to protect and synchornize access to mutable state.
- [x] Use of Coding protocol, Plist and JSON encoding / decoding for response decoding and persistance. 
- [x] Use of Combine to bind the view model to the view.
- [x] Use of diffable data source to regulate updates to the table view.
- [x] Use of a custom image loader with cache to make the UI performant. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/abhandary/reqres/blob/main/imdb_movies.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


## License

    Copyright [2022] [Akshay Bhandary]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
