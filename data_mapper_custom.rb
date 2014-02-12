require 'dm-core'
require 'dm-do-adapter'
 
# Credits to kabakiyo for the ILIKE Comparator.
 
module DataMapper
  class Query
    module Conditions
      class SimilarToComparison < AbstractComparison
        slug :similar
 
        private
 
        # Overloads the +expected+ method in AbstractComparison
        #
        # Expects the input value to be a valid Regular expression.
        #
        # @return [Regexp]
        #
        # @see AbtractComparison#expected
        #
        # @api semipublic
        def expected
          loaded_value.kind_of?(Regexp)
        end
 
        # @return [String]
        #
        # @see AbstractComparison#to_s
        #
        # @api private
        def comparator_string
          'SIMILAR TO'
        end
      end # class LikeComparison
      class ILikeComparison < AbstractComparison
        slug :ilike
 
        private
 
        # Overloads the +expected+ method in AbstractComparison
        #
        # Return a regular expression suitable for matching against the
        # records value.
        #
        # @return [Regexp]
        #
        # @see AbtractComparison#expected
        #
        # @api semipublic
        def expected
          Regexp.new('\A' << super.gsub('%', '.*').tr('_', '.') << '\z')
        end
 
        # @return [String]
        #
        # @see AbstractComparison#to_s
        #
        # @api private
        def comparator_string
          'ILIKE'
        end
      end # class LikeComparison
    end
  end
 
  module Adapters
    class DataObjectsAdapter < AbstractAdapter
      module SQL #:nodoc:
 
        alias :old_comparison_operator :comparison_operator
 
        def comparison_operator(comparison)
          case comparison.slug
            when :similar  then 'SIMILAR TO'
            when :ilike  then 'ILIKE'
            else old_comparison_operator(comparison)
          end
        end
      end
    end
  end
end
 
class Symbol
  def ilike
    DataMapper::Query::Operator.new(self, :ilike)
  end
 
  def similar
    DataMapper::Query::Operator.new(self, :similar)
  end
end # class Symbol