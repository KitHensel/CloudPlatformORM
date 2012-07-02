module Quickbase
  module Storable
    MAX_RECORDS_PER_WRITE = 10000

    # CSV import of an array of model objects
    def save_all(models, field_names=nil)
      raise "database_id not specified" unless database_id
      
      field_names ||= fields.keys
      header = build_csv_header(field_names)
      rows = models.map {|model| build_csv_row(model, field_names) }
      rows.each_slice(MAX_RECORDS_PER_WRITE) do |chunk|
        store_chunk(header, chunk)
      end
    end

    private

    def store_chunk(header, chunk)
      csv_data = CSV.generate { |csv| chunk.each {|row| csv << row }}.escape_xml
      3.attempts do
        connection.client.importFromCSV(database_id, csv_data, header)
      end
    end
    
    def build_csv_header(field_names)
      columns = field_names.map {|name| field_id(name) }.join(".")
    end

    def build_csv_row(model, field_names)
      field_names.map do |field_name|
        model.send(field_name)
      end
    end
  end
end