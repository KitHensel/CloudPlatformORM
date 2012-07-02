module Quickbase
    module Selectable
        def find(id)
            Selector.new(self).where(:id => id).first
        end

        def where(criterion)
            Selector.new(self).where(criterion)
        end 

        def all
            Selector.new(self).all
        end

        class Selector
            attr_accessor :model, :selector

            def initialize(model)
                self.model = model
                self.selector = []
            end

            def all
                selector.clear
                selection
            end

            def where(criterion)
                selection(criterion)
            end

            def and(criterion)
                selection(criterion)
            end

            def or(criterion)
                selection(criterion, 'OR')
            end

            def to_a
                model.query(build_query)
            end

            private

            def selection(criterion=[], condition='AND')
                self.selector << condition if (selector.size > 0) && (criterion.size > 0)
                self.selector += criterion.inject([]) {|memo, name_value|
                    field_name, value = name_value
                    memo << "AND" if memo.size > 0
                    memo << Criteria.new(model.field_id(field_name), value, 'EX')
                }
                self
            end

            def build_query
                selector.map(&:to_s).join
            end
        end

        class Criteria
            attr_accessor :field_id, :value, :operator

            def initialize(field_id, value, operator)
                self.field_id = field_id
                self.value = value
                self.operator = operator
            end

            def to_s
                '{' + "#{field_id}.#{operator}.'#{value}'" + '}'
            end
        end
    end
end