module Spectifly
  module Xsd
    class Types
      Native = [
        'boolean',
        'string',
        'date',
        'date_time',
        'integer',
        'non_negative_integer',
        'positive_integer',
        'decimal',
        'base64_binary'
      ]

      Extended = Spectifly::Types::Extended

      class << self
        def build_extended(xml = nil)
          xml ||= ::Builder::XmlMarkup.new(:indent => 2)
          xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
          xml.xs :schema, 'xmlns:xs' => "http://www.w3.org/2001/XMLSchema", 'elementFormDefault' => "qualified" do
            Extended.each_pair do |name, attributes|
              field = Spectifly::Xsd::Field.new(name.dup, attributes.dup)
              field.type_block(true).call(xml)
            end
          end
        end
      end
    end
  end
end