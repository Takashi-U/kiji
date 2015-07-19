require 'spec_helper'

describe Kiji::ApplicantComponentXml do
  applicant_component_xml = Kiji::ApplicantComponentXml.new
  describe '#edit_node and #xpath' do
    it 'can add node and read node' do
      applicant_component_xml.edit_node("//申請者情報/氏名フリガナ","ほげ　ほげ")
      expect(applicant_component_xml.at_xpath("//申請者情報/氏名フリガナ").content).to eq "ほげ　ほげ"
    end
  end

  describe '#generate_xml_document' do
    it 'generate valid object for Signer class argument' do
      KEY = 'spec/fixtures/e-GovEE01_sha2.pfx'
      PASSWORD = 'gpkitest'

      pkcs12 = OpenSSL::PKCS12.new(File.open(KEY),PASSWORD)
      signer = Kiji::Signer.new(applicant_component_xml.generate_xml_document) do |s|
        s.cert = pkcs12.certificate
        s.private_key = pkcs12.key
        s.digest_algorithm           = :sha256
        s.signature_digest_algorithm = :sha256
      end
      signer.security_node = signer.document.at_xpath("//署名情報")
      signer.digest!(signer.document.at_xpath('//構成情報'), id: "#" + URI.escape('構成情報'))
      attached_file = "spec/fixtures/495000020419029959_01.xml"
      signer.digest_file!(File.read(attached_file), id: URI.escape(attached_file))
      signer.signature_node
      signer.signed_info_node
      signer.x509_data_node

      #申請書のハッシュ値しか確認していない。
      expect(signer.sign!.to_xml).to match /DigestValue>MWvIjVyUx\/1o2WCZHy8DmJuKmRL\/QPqyeRS8ncYeCjI=/
    end
  end

end
