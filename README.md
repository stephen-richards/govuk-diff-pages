
# govuk-diff-pages

This app provides a rake task to produce visual diffs as screenshots of the most popular pages on staging 
and production environements of the gov.uk website.

## Screenshots

![Example output](doc/screenshosts/gallery.png?raw=true "Example gallery of differing pages")


## Technical documentation

It uses a fork of the BBC's wraith gem (The fork is at https://github.com/alphagov/govuk-diff-pages, the 
main gem at https://github.com/BBC-News/wraith).  The fork adds two extra configuration variables, allowing the 
user to specify the number of threads to use, and the maximum timeout when loading pages.  The output is written 
to an html file which can be viewed in a browser.


### Dependencies

- [ImageMagick] (http://www.imagemagick.org/script/index.php)
- [phantomjs] (http://phantomjs.org/) - preferbaly 1.9 rather than 2.0


### Running the application

`bundle exec rake diff`


### Running the test suite

`bundle exec rake`


## Licence

[MIT License](LICENCE)

