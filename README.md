**chm2pdf** Convert CHM to PDF

~~~~
bundle exec rake convert
~~~~

The script is dependent on the `extract_chmLib` executable which is a part of the [chmlib](http://www.jedrea.com/chmlib) package. It also uses the `htmldoc` executable from [htmldoc](https://www.msweet.org/htmldoc) package. These packages should be present in the system.

The script is written in the [Ruby](https://www.ruby-lang.org) programming language. It also should be present in the system.

The script is dependent on [Bundler](https://bundler.io), the Ruby dependency manager. Install it using `gem install bundler`. `gem` executable is a part of the Ruby distribution.

After Bundler installation, install through it the Ruby dependencies for the script by running `bundle install --path=vendor/bundle`. There are two such dependencies `rake`, the executable used for running the script and `nokogiri`, an XML/HTML parser used for searching in CHM document pages to get information to properly assemble the resulting PDF document and also to remove some elements specific to CHM documents which aren't needed in PDF documents.

To convert a CHM document to a PDF document rename a CHM document to `book.chm`, place it in the current directory and run `bundle exec rake convert`. The resulting PDF document will have the name `book.pdf`.

In case `book.chm` is a book of O'Reilly publishing (there are a lot of old books of this publisher, which don't have a PDF version), it will be stripped from the _next_ and _previous_ navigation elements and also the inserts with bibliographic information (title, publisher, publication date, ISBN) on the _Overview_ page and the _Contents_ page. The navigation elements are not needed in the PDF document, since the PDF viewer means are used for navigation. As for the inserts, they are design elements of the CHM format of documents and don't look nice in PDF documents. Moreover, the most books have a separate page with bibliographic information. There's no need to duplicate it.

The resulting PDF document will be luck of page numbering and title page. It's recommended to use third-party soft to address these issues.

The resulting PDF document will have bookmarks with entries linked to the book parts, chapters and sections. They will have plain structure, not treelike one with sections inside chapters and chapters inside parts. It's also recommended to use third-party soft to structure bookmarks according to your needs and wishes.

If you have any questions, please, ask in issues in any form and any language.

There are other projects to achive the same goal.

• [chm2pdf](https://github.com/opexxx/chm2pdf) One more Ruby script by Alexander Knorr

• [chm2pdf](https://github.com/Arnoques/chm2pdf) A Python script by Arnoques
