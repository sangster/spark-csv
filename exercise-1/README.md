# Exercise 1

## Example usage

Install any missing gems first, with `bundler`.

```sh
./go.rb test/files/contacts.csv
```

## Original Requirements

You have been provided a CSV containing a list of leads for a sales center.
Each row includes key contact information and may or may not include responses
to questions the center has asked. Some lead entries are unique and complete,
others were not entirely filled out, and others still were entered twice, but
sometimes with new answers.

Build a program in Ruby (without a database) that can:

1. Import the contacts CSV (included)

2. List only the valid contact records (not duplicate or incomplete), with each
contact appearing only once with the answers they have most recently added (if
they have any answers at all).

3. Report
  - total contacts
  - duplicate contacts
  - incomplete contacts (rows for which there is no value for one or more
    headers, excluding Q&A columns)

3. Map the questions in a way that each question can be associated with the
contacts who have answered it.

4. Return each invalid record with an error message stating why it was rejected.


## Development

### Testing

A few Rake commands will help your testing:

  - `rake test`: Run the test suite
  - `rake lint`: Run the code linters
  - `rake`: Run all tests and linters

### Guard

To facilitate development, consider running `bundle exec guard` in the
background while you work. Whenver a source file it changed, it will
automatically run the relevent tests. This will provide you immediate test
feedback at all times.
