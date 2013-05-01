module Spectifly
  module Xsd
    module Types
      Native = [
        'boolean',
        'string',
        'date',
        'date_time',
        'integer',
        'non_negative_integer',
        'positive_integer',
        'decimal'
      ]

      Extended = Spectifly::Types::Extended
    end
  end
end