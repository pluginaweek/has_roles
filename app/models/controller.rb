# Represents the name of a controller in the code.  The name of the controller
# includes its namespace, if any.
class Controller < ActiveRecord::Base
  has_many  :permissions,
              :dependent => :destroy
  
  validates_presence_of   :path
  validates_format_of     :path,
                            :with => /\A[a-z\/]\Z/i
  validates_uniqueness_of :path
  validates_length_of     :path,
                            :minimum => 1
  
  class << self
    # 
    def ordered_by_parent
      controllers_by_parent = Controller.find(:all).inject(ActiveSupport::OrderedHash.new) do |controllers, controller|
        controller.klass.parents.each {|parent| controllers[parent] ||= []}
        controllers[controller.klass.parent] << controller
        controllers
      end
      
      controllers_by_parent.each do |parent, controllers|
        controllers.sort! do |c1, c2|
          c1.name <=> c2.name
        end
      end
      
      controllers_by_parent.sort! do |c1, c2|
        if c1.first == Object
          -1
        elsif c2.first == Object
          1
        else
          c1.first.name <=> c2.first.name
        end
      end
    end
    
    # Parses the controller path and action from the given options
    def recognize_path(options = '')
      options = ActionController::Routing::Routes.recognize_path(URI.parse(options).path) if options.is_a?(String)
      controller_path, action = options[:controller], options[:action].to_s
      controller_path = controller_path.controller_path if controller_path.is_a?(Class)
      
      return controller_path, action
    end
  end
  
  # Returns the class that this controller represents
  def klass
    @klass ||= "#{path.camelize}Controller".constantize
  end
  
  # The humanized name of this controller.  This will not include the parent's name.
  def name
    @name ||= klass.controller_name.titleize
  end
  
  # Possible paths that can match this controller
  def possible_path_matches
    klass.ancestors.select {|c| Class === c && c < ActionController::Base}.map(&:controller_path)
  end
  
  # Is this a global controller?  If a user has a permission on the global
  # controller, then he has permissions on all controllers.  At least one user
  # in the system must have global access.
  def global?
    path == 'application'
  end
  
  # Returns the name of the controller
  def to_s #:nodoc
    name
  end
end
