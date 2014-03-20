require 'csv'

module QuickbaseMapper::Storable
  MAX_RECORDS_PER_WRITE = 10000

  attr_accessor :persisted

  def save!
    self.class.save_all([self])
  end

  module ClassMethods

    def create!(attributes)
      object = new(attributes)
      object.save!
      object
    end

    def purge!(criteria)
      connection.client.purgeRecords(database_id, criteria)
    end

    def createmany!(attributes)
      records = attributes.map do |record|
        new(record)
      end

      save_all(records)
    end

    # CSV import of an array of model objects
    def save_all(models, field_names=nil)
      raise "database_id not specified" unless database_id
      
      field_names ||= fields.keys
      header = build_csv_header(field_names)

      models.each_slice(MAX_RECORDS_PER_WRITE) do |chunk|
        csv_chunk = CSV.generate do |csv|
          chunk.each do |object| 
            csv << build_csv_row(object, field_names) 
          end
        end

        Rails.logger.info "Headers: #{header}"
        Rails.logger.info "CSV Chunk: #{csv_chunk}"
        store_chunk(header, csv_chunk, chunk)
      end
    end

    private

    def store_chunk(header, csv, objects)
      3.attempts do
        n, m, o, rids, p = connection.client.importFromCSV(database_id, csv, header)
        rids = parse_rid_xml rids
        if rids.size == objects.size
          objects.zip(rids).each {|object, id| object.id = id }
        else
          raise "record ids returned #{rids.size} does not match records saved #{objects.size}" 
        end
      end
    end

    def parse_rid_xml(xml)
      xml.select {|result| 
        result.is_a? REXML::Element
      }.map {|rid_xml|
        rid_xml.text
      }
    end
    
    def build_csv_header(field_names)
      columns = field_names.map {|name| field_id(name) }.join(".")
    end

    def build_csv_row(model, field_names)
      field_names.map do |field_name|
        value = model.send(field_name).to_s
      end
    end
  end
end