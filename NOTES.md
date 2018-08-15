# Notes

## Exercise 1

See `exercise-1/README.md` for more information about this exercise.

## Exercise 2

This exercise contained two small small scripts. Normally, I like ruby scripts
to include scripts and follow the typical RubyGem folder structure (`./lib`,
`./test`, and frields); however, these scripts are just too small to warrant so
much overhead. Scripts of this nature are normally used for prototyping or
developer-quality-of-life purposes.

For this reason, I opted to simply refactor these two scripts as-is (as-are?),
focusing mainly on readability and maintenance.

### Major changes

  - Extracting "magic numbers", including:
    - The CSV input file and the number of rows generated. These can optionally
      be passed via commandline arguments.
    - The hard-coded HTML. The format of the HTML is supplied by an ERB
      template. This template can be supplied via the commandline or default to
      the provided one: `template.html.erb`
  - Improved Readability/Maintenance:
    - Extracted code into methods with Yardoc comments where needed
    - Replaced superfluous code ruby idioms
    - Refactored both scripts to conform to Rubocop's default rules
