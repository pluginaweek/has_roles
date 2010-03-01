class HasRolesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template '001_create_permissions.rb', 'db/migrate', :migration_file_name => 'create_permissions'
      m.sleep 1
      m.migration_template '002_create_roles.rb', 'db/migrate', :migration_file_name => 'create_roles'
      m.sleep 1
      m.migration_template '003_create_role_permissions.rb', 'db/migrate', :migration_file_name => 'create_role_permissions'
      m.sleep 1
      m.migration_template '004_create_role_assignments.rb', 'db/migrate', :migration_file_name => 'create_role_assignments'
    end
  end
end
