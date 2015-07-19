require 'spec_helper'

describe Kiji::ApplicantComponentXml do
  applicant_component_xml = Kiji::ApplicantComponentXml.new
  applicant_component_xml.edit_node("//申請者情報/氏名フリガナ","ほげ　ほげ")
  it '#edit_node and #xpath' do
    expect(applicant_component_xml.at_xpath("//申請者情報/氏名フリガナ").content).to eq "ほげ　ほげ"
  end
end
