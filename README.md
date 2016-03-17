# govuk-diff-pages

This app provides a rake task to produce visual diffs as screenshots, HTML
diffs and textual diffs of the production GOVUK website as compared with
staging. Viewable as browser pages or directly in the terminal. It looks at the
10 most popular pages (this is configurable) of each document format.

## Screenshots

![Example output](docs/screenshots/gallery.png?raw=true "Example gallery of
differing pages")


## Technical documentation for visual and HTML diffs

It uses a fork of the BBC's wraith gem (The fork is at
https://github.com/alphagov/wraith, the main gem at
https://github.com/BBC-News/wraith).  The fork adds two extra configuration
variables, allowing the user to specify the number of threads to use, and the
maximum timeout when loading pages.  The output is written to an html file
which can be viewed in a browser.

When `bundle exec rake diff` is run, a list of all the document formats on
govuk is obtained using the search api, and then the top n pages for each
format (n being a configuration variable).  Diffs are produced for each of
these pages.


### Dependencies

- [ImageMagick] (http://www.imagemagick.org/script/index.php)
- [phantomjs] (http://phantomjs.org/) - preferbaly 1.9 rather than 2.0


## How to run

### Running the application locally

  bundle exec rake diff

### Checking plain-text diffs

  bundle exec rake diff:text pages.yml

Where `pages.yml` is a YAML array of paths to compare. For example:

  - government/organisations/prime-ministers-office-10-downing-street
  - government/topical-events/budget-2016
  - topic/competition/regulatory-appeals-references

Text diffs can also specify the domains to compare using the `LEFT` and `RIGHT`
environment variables. Defaulting to our `www-origin.staging` and
`www-origin.publishing` domains respectively.

Plain-text diffing can be parallelised by starting multiple processes with
individual page files.

### Using the gem from an existing project

  # Gemfile
  gem 'govuk-diff-pages'

  # Rakefile
  load 'govuk/diff/pages/tasks/rakefile.rake'

  # Shell
  bundle exec rake -T

### Running the test suite

  bundle exec rake

## Licence

[MIT License](LICENCE.txt)
