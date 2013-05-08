require 'builder'
require_relative 'field'
require_relative 'types'

module Spectifly
  module Xsd
    class Builder < Spectifly::Base::Builder
      def root_type
        Spectifly::Support.lower_camelize("#{root}Type")
      end

      def build_type(xml = nil)
        xml ||= ::Builder::XmlMarkup.new(:indent => 2)
        xml.xs 'complexType'.to_sym, :name => root_type do
          xml.xs :sequence do
            fields.each do |field|
              field.to_xsd(xml)
            end
          end
        end
      end

      def build(xml = nil)
        xml ||= ::Builder::XmlMarkup.new(:indent => 2)
        xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
        xml.xs :schema, 'xmlns:xs' => "http://www.w3.org/2001/XMLSchema", 'elementFormDefault' => "qualified" do
          custom_types.each do |cust|
            xml.xs :include, 'schemaLocation' => "#{cust}.xsd"
          end
          unless utilized_extended_types.empty?
            xml.xs :include, 'schemaLocation' => "extended.xsd"
          end
          xml.xs :element, :name => Spectifly::Support.camelize(root), :type => root_type
          build_type(xml)
        end
      end
    end
  end
end