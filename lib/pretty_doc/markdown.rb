require 'kramdown'
require 'nokogiri'
require 'pygments'
require 'pretty_doc/converter'

module PrettyDoc
  # Markdown Converter
  class Markdown < Converter
    def self.perfer_exts
      ['.md', '.markdown', '.mdown', '.txt']
    end

    def before_convert
      self.content = content
        .gsub(/\[NO_TOC\]\n/, "{:.no_toc}\n")
        .gsub(/\[TOC\]\n/, "+ __toc_line__\n{:toc}\n")
    end

    def convert
      before_convert
      html = Kramdown::Document.new(
        content,
        input: :GFM,
        enable_coderay: false,
        toc_levels: [1, 2, 3, 4, 5, 6]
      ).to_html

      doc = Nokogiri::HTML::DocumentFragment.parse(html)

      figure_role(doc)
      code_block(doc)
      doc.to_html
    end

    def code_block(doc)
      doc.css('pre > code[class^=language]').each do |code_node|
        lang = (code_node['class'].scan(/language-([^\s]+)/).first || []).first
        highlight_code_block(code_node, lang)
      end

      doc.css('pre[lang] > code').each do |code_node|
        lang = code_node.parent['lang']
        highlight_code_block(code_node, lang)
      end
    end

    def highlight_code_block(code_node, lang)
      pre = code_node.parent
      code_output = highlight(code_node.content, lang)
      code_doc = Nokogiri::HTML::DocumentFragment.parse(code_output)
      pre.replace code_doc.children
    end

    def highlight(content, lang)
      highlighted_code = Pygments.highlight(
        content,
        lexer: lang,
        formatter: 'html',
        options: { encoding: 'utf-8' }
      )
      str = highlighted_code.match(/<pre>(.+)<\/pre>/m)[1].to_s.gsub(/ *$/, '')
      tableize_code(str, lang)
    end

    def tableize_code (str, lang = '')
      line_number = code = ''
      str.lines.each_with_index do |line, index|
        line_number += "<span class='line-number'>#{index + 1}</span>\n"
        code += "<span class='line'>#{line}</span>"
      end

      table = <<-HTML
        <div class="highlight">
          <table>
            <tr>
              <td class="lines">
                <pre class="line-numbers">#{line_number}</pre>
              </td>
              <td class="code">
                <pre><code>#{code}</code></pre>
              </td>
            </tr>
          </table>
        </div>
      HTML
      table
    end

    def figure_role(doc)
      doc.css('p[role=figure]').each do |p|
        p.remove_attribute 'role'
        p.name = 'figure'
        p['class'] = 'thumbnail'
        p.css('em').each { |s| s.name = 'figcaption' }
        p.css('strong').each { |s| s.name = 'figcaption' }
      end
    end
  end
end