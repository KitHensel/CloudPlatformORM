module Quickbase
    module Queryable
        def query(clause, selected_field_ids=nil)
            clist = (selected_field_ids || fields.values).join('.')
            results = connection.doQuery(database_id, clause, nil, nil, clist)
            process_query_results(results)
        end

        private

        def process_query_results(results)
            records = results.select { |result| result.is_a? REXML::Element }
            records.map do |record|
              attributes = {}
              fields = record.select {|result| result.is_a? REXML::Element }
              fields.each do |field|
                id = field.attributes['id']
                attributes[id] = field.text 
              end
              self.new(attributes)
            end
        end
    end
end