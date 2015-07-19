require 'nokogiri'

module Kiji
  class ApplicantComponentXml
    attr_reader :xml_doc
    def initialize
      @xml_doc = Nokogiri::XML(File.read(File.dirname(__FILE__) + "/format/applicant_component_xml.xml"), nil, "UTF-8")
    end

    def edit_node(node, inner_text)
      @xml_doc.at_xpath(node).content = inner_text
    end

    def at_xpath(node)
      @xml_doc.at_xpath(node)
    end
    
    def generate_xml_document
      @xml_doc
    end
  end
end
