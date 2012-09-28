module QuickbaseMapper::Queryable
  module ClassMethods
    MAX_QUERY_SIZE = 2000

    def query(clause, selected_field_ids=nil)
      clist = (selected_field_ids || fields.values).join('.')
      record_count = count(clause)
      records = []
      while records.count < record_count
        results = client.doQuery(database_id, clause, nil, nil, clist, nil, "structured", "num-#{MAX_QUERY_SIZE}.skp-#{records.count}")
        records += process_query_results results
      end

      # results = connection.doQuery(database_id, clause, nil, nil, clist)
      # process_query_results(results)

      records
    end

    def count(query=nil)
      if (query)
        connection.doQueryCount(database_id, query).to_i
      else
        connection.getNumRecords(database_id).to_i
      end
    end

    private

    def process_query_results(results)
      records = results.select { |result| result.is_a? REXML::Element }
      records.map do |record|
        attributes = {}
        fields = record.select {|result| result.is_a? REXML::Element }
        fields.each do |field|
          id = field.attributes['id'].to_i
          name = field_name(id)
          attributes[name] = field.text if name
        end
        self.new(attributes)
      end
    end
  end
end
