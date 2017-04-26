require 'csv'
require 'csv_format_guesser'
describe CsvFormatGuesser do

  let(:guesser) { CsvFormatGuesser.new(file) }
  subject {guesser}

  context 'tab separated' do
    let(:file) { 'spec/fixtures/files/tab_separated.csv' }
    its(:col_sep) { should == "\t" }
    its(:encoding) { should == 'ISO-8859-2' } # latin-2
    its(:quote_char) { should == "'" }
  end


  context 'hash separated' do
    let(:file) { 'spec/fixtures/files/hash_separated_utf8.csv' }
    its(:col_sep) { should == '#' }
    its(:encoding) { should == 'utf-8' }
    its(:quote_char) { should == "'" }
  end

  context 'pipe separated' do
    let(:file) { 'spec/fixtures/files/pipe_separated.csv' }
    its(:col_sep) { should == '|' }
    its(:encoding) { should == 'utf-8' }
    its(:quote_char) { should == "\x00" }
  end

  context 'broken excape' do
    let(:file) { 'spec/fixtures/files/broken_escape.csv' }
    its(:col_sep) { should == ';' }
    its(:encoding) { should == 'utf-8' }
    its(:quote_char) { should == "\x00" }
  end

  context 'navision' do
    let(:file) { 'spec/fixtures/files/navision_export_sample.csv' }
    its(:col_sep) { should == ',' }
    its(:quote_char) { should == '"' }
    its(:encoding) { should == 'ISO-8859-7' }
  end

  context 'concurrent # and , as separators' do
    let(:file) { 'spec/fixtures/files/concurrent_separators.txt' }
    its(:col_sep) { should == '#' }
  end

  context 'iso 8859-2' do
    let(:file) { 'spec/fixtures/files/iso_8859-2.csv' }
    its(:encoding) { should == 'ISO-8859-2' }
    its(:col_sep) { should == ';' }
    its(:quote_char) { should == "\x00" }
  end

end

