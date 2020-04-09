require 'tmpdir'
require 'nokogiri'

module CHMtoPDF
  def unpack_chm chm_file, tmpdir
    %x{ `which extract_chmLib` #{chm_file} #{tmpdir} }
  end

  def get_hhc_file_path tmpdir
    Dir.chdir tmpdir do |dir| File.join dir, Dir.glob('*.hhc') end
  end

  def assemble_contents_list tmpdir
    File.open get_hhc_file_path tmpdir do |f|
      Nokogiri::HTML::Document.parse(f).then do |d|
        @contents = d.css('object[type="text/sitemap"] param[name="Local"]').map { |e| File.join tmpdir, e[:value] }
      end
    end
  end

  def remove_unnecessary_elements contents
    contents.each do |p|
      File.open p, 'r+' do |f|
        Nokogiri::HTML::Document.parse(f).then do |d|

          # Remove "prev" and "next" labels from pages of O'Reilly books
          d.css('a img[src="images/prev.gif"], a img[src="images/next.gif"]').each do |n|
            n.parent.remove
          end

          # Remove the book data (cover miniature, title, ISBN, etc.) from the
          # overview page and from the TOC page of O'Reilly books
          d.css('body table:nth-child(3)').each do |n|
            n.remove if File.basename(f.path).eql? 'main.html' or File.basename(f.path).eql? 'toc.html'
          end

          # Remove the "Table of Contents" and "Index" links block from the top
          # of the overview page and the TOC page
          d.css('td[class="aTopMenu"]').each do |n|
            n.parent.parent.remove if File.basename(f.path).eql? 'main.html' or File.basename(f.path).eql? 'toc.html'
          end

          f.truncate 0
          f.write d
        end
      end
    end
  end

  def create_pdf contents, output
    %x{ `which htmldoc` --webpage --bottom 18.7mm --header . --footer . --outfile #{output} #{contents.join ' '} }
  end

  def convert input, output
    Dir.mktmpdir 'chm2pdf-' do |tmpdir|
      unpack_chm input, tmpdir
      assemble_contents_list tmpdir
      remove_unnecessary_elements @contents
      create_pdf @contents, output
    end
  end

  module_function :unpack_chm, :get_hhc_file_path, :assemble_contents_list, :remove_unnecessary_elements, :create_pdf, :convert
end
