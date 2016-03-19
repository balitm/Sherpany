# Sherpany

Exercise app.

An iPad application that downloads data in JSON format from a RESTful web service and makes it possible to navigate in the remote database. The app conforms with the requirements below, given the provided endpoints.

Requirements:

1. Display a table with all the users.
  - For each user, the following data should be displayed, vertically aligned:
    - Name
    - Email
    - Company catch phrase
  - Endpoint: http://jsonplaceholder.typicode.com/users

2. By selecting a user, all the albums names related to that user (userId) should be displayed in a table.
  - The navigation bar should display the name of the user.
  - Endpoint: http://jsonplaceholder.typicode.com/albums

3. When an album is selected, a list with all the photos of that album (albumId) should be presented, next to each photo present its title.
  - The navigation bar should display the name of the selected album.
  - Endpoint: http://jsonplaceholder.typicode.com/photos
  - Photo: “thumbnailUrl” JSON parameter

4. Provide UI feedback where you see fit.
   
5. Bonus points
  - Present the title “Users” in the table with all the users. Localize the title in English, German and French.
  - Include unit tests.
  - Include a search bar to search for users.
  - Cache relevant content.
  - Persist data.