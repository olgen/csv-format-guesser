# CsvFormatGuesser

Guess format and encoding of .csv/.tsv files to generate options compatible with ruby CSV class. 

## Installation

Add this line to your application's Gemfile:

    gem 'csv-format-guesser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv-format-guesser

## Usage

require 'csv'
require 'csv_format_guesser'

path = 'sample.csv'
opts = CsvFormatGuesser.new(path).csv_opts
CSV.open(path, opts).each do |line|
  puts line
end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
