##
# Provides the interface to convert the JSON response from the API
# to a Ruby Object
#
module BusinessCentral::Response
  class ResponseHandler
    attr_accessor :dataset
    attr_accessor :compiled_data

    # Constructor
    #
    # Params:
    # +dataset+: +Hash+|+Array+ the result from the API query
    def initialize(dataset)
      @compiled_data = []
      @dataset = dataset
      process
    end

    # Compiles the data in the @dataset to the supplied class
    #
    def process
      @dataset.is_a?(Array) ? process_array : process_data(@dataset)
    end

    def process_array
      @dataset.each do |data|
        process_data(data)
      end
    end

    def process_data(data)
      new_record = JSON.parse(sanitize(data), object_class: OpenStruct)

      unless data["@odata.etag"].nil?
        new_record.etag = data["@odata.etag"]
      end
      @compiled_data << new_record
    end

    def sanitize(data)
      data.is_a?(Hash) ? data.to_json : data
    end
  end
end
