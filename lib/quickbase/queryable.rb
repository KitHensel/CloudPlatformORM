module Quickbase
    module Queryable
        def query(clause, selected_field_ids=nil)
            clist = (selected_field_ids || fields.values).join('.')
            results = connection.doQuery(database_id, clause, nil, nil, clist)
            process_query_results(results)
        end

        private

        def process_query_results(results)
            results = results.select { |result| result.is_a? REXML::Element }
            object_results = results.map { |result|
                p result
            }
        end
    end
end