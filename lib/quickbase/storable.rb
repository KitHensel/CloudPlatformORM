module Quickbase
  module Storable
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

      # CSV import of an array of model objects
      def save_all(models, field_names=nil)
        raise "database_id not specified" unless database_id
        
        field_names ||= fields.keys
        header = build_csv_header(field_names)
        # rows = models.map {|model| build_csv_row(model, field_names) }
        # rows.each_slice(MAX_RECORDS_PER_WRITE) do |chunk|
        #   store_chunk(header, chunk)
        # end
        models.each_slice(MAX_RECORDS_PER_WRITE) do |chunk|
          csv_chunk = chunk.map {|model| build_csv_row(model, field_names) }
          store_chunk(header, csv_chunk, chunk)
        end

      end

      private

      def store_chunk(header, chunk, objects)
        3.attempts do
          n, m, o, rids, p = connection.client.importFromCSV(database_id, chunk, header)
          if rids.size == chunk.size
            objects.zip(rids).each {|object, id| object.id = id }
          else
            p rids
            p chunk
            raise "record ids returned #{rids.size} does not match records saved #{chunk.size}" 
          end
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
end