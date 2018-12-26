#  Music Manager

Currently, this is an extrememly hacky CLI that I wrote in Swift to help me move my music library from Apple Music to Spotify.

## Steps

Here are the steps that I took in order to get some success.

1. Open iTunes and export library as XML file.
2. Use another CLI to convert the XML file to more easily-managed JSON. The CLI I used is [itunes-data](https://github.com/shawnbot/itunes-data).
3. My program loads the JSON data.
4. My program uses the Spotify API to search for the songs on Spotify, and saves all the matches it found and the songs for which it could not find a match.
5. The user then needs to open up a web page and extract the access token from the url that is redirected to and save it in the appropriate file. This is the hackiest part. My program will wait until they have done this.
6. My program adds all the matches to the user's Spotify library.

## Improvement

There is so much potential with this project. A mobile application could be built for typical users to move their libraries. The search algorithm could be significantly refined. The potential is limitless