
# govuk-diff-pages

This app provides a rake task to produce visual diffs as screenshots, and HTML diffs, of the production GOVUK website as compared with staging. Both are viewable as browser pages.  It looks a the 10 most popular pages (this is configurable) of each document format.

## Screenshots

![Example output](docs/screenshots/gallery.png?raw=true "Example gallery of differing pages")


## Technical documentation

It uses a fork of the BBC's wraith gem (The fork is at https://github.com/alphagov/govuk-diff-pages, the 
main gem at https://github.com/BBC-News/wraith).  The fork adds two extra configuration variables, allowing the 
user to specify the number of threads to use, and the maximum timeout when loading pages.  The output is written 
to an html file which can be viewed in a browser.

When `bundle exec rake diff` is run, a list of all the document formats on govuk is obtained using the search api, and then the top n pages for each format (n being a configuration variable).  Diffs are produced for each of these pages.


### Dependencies

- [ImageMagick] (http://www.imagemagick.org/script/index.php)
- [phantomjs] (http://phantomjs.org/) - preferbaly 1.9 rather than 2.0


### Running the application

`bundle exec rake diff`


### Running the test suite

`bundle exec rake`


## Licence

[MIT License](LICENCE)

