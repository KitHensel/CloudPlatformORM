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

    # def add!(attributes)
    #   object = new(attributes)
    #   object.class.save_record([object])
    # end

    # CSV import of an array of model objects
    def save_all(models, field_names=nil)
      raise "database_id not specified" unless database_id
      
      field_names ||= fields.keys
      header = build_csv_header(field_names)

      puts header
      Rails.logger.info header

      models.each_slice(MAX_RECORDS_PER_WRITE) do |chunk|
        csv_chunk = CSV.generate do |csv|
          chunk.each do |object| 
            csv << build_csv_row(object, field_names) 
          end
        end
        store_chunk(header, csv_chunk, chunk)
      end
    end

    # def save_record(models, field_names=nil)
    #   raise "database_id not specified" unless database_id

    #   field_names ||= fields.keys

    #   connection.client.clearFieldValuePairList
    #   model = models.first

    #   field_names.each do |field|
    #     value = model.send(field)
    #     field_id = field_id(field)

    #     if value.original_value.kind_of? Array
    #       connection.client.addFieldValuePair(nil, field_id, value.first, value.second)
    #     else
    #       connection.client.addFieldValuePair(nil, field_id, nil, value)
    #     end
    #   end
    #   10.attempts do
    #     connection.client.addRecord(database_id, connection.client.fvlist)
    #   end
    # end

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