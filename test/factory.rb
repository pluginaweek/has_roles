module Factory
  # Build actions for the class
  def self.build(klass, &block)
    name = klass.to_s.underscore
    define_method("#{name}_attributes", block)
    
    module_eval <<-end_eval
      def valid_#{name}_attributes(attributes = {})
        #{name}_attributes(attributes)
        attributes
      end
      
      def new_#{name}(attributes = {})
        #{klass}.new(valid_#{name}_attributes(attributes))
      end
      
      def create_#{name}(*args)
        record = new_#{name}(*args)
        record.save!
        record.reload
        record
      end
    end_eval
  end
  
  build Permission do |attributes|
    attributes.reverse_merge!(
      :id => 1,
      :controller => 'admin/users'
    )
  end
  
  build Role do |attributes|
    attributes.reverse_merge!(
      :id => 1,
      :name => 'developer'
    )
  end
  
  build RoleAssignment do |attributes|
    attributes[:role] = create_role unless attributes.include?(:role)
    attributes[:assignee] = create_user unless attributes.include?(:assignee)
  end
  
  build User do |attributes|
    attributes.reverse_merge!(
      :login => 'admin'
    )
  end
end
