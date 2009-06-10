# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_roles}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Pfeifer"]
  s.date = %q{2009-06-08}
  s.description = %q{Demonstrates a reference implementation for handling role management in ActiveRecord}
  s.email = %q{aaron@pluginaweek.org}
  s.files = ["app/models", "app/models/role_assignment.rb", "app/models/role_permission.rb", "app/models/role.rb", "app/models/permission.rb", "db/migrate", "db/migrate/003_create_role_permissions.rb", "db/migrate/001_create_permissions.rb", "db/migrate/002_create_roles.rb", "db/migrate/004_create_role_assignments.rb", "lib/has_roles", "lib/has_roles/url_helper.rb", "lib/has_roles/authorization_helper.rb", "lib/has_roles.rb", "test/unit", "test/unit/role_test.rb", "test/unit/permission_test.rb", "test/unit/role_permission_test.rb", "test/unit/role_assignment_test.rb", "test/helpers", "test/helpers/authorization_helper_test.rb", "test/helpers/url_helper_test.rb", "test/factory.rb", "test/app_root", "test/app_root/app", "test/app_root/app/models", "test/app_root/app/models/user.rb", "test/app_root/app/controllers", "test/app_root/app/controllers/users_controller.rb", "test/app_root/app/controllers/home_controller.rb", "test/app_root/app/controllers/admin", "test/app_root/app/controllers/admin/users_controller.rb", "test/app_root/app/controllers/admin/base_controller.rb", "test/app_root/app/controllers/application_controller.rb", "test/app_root/db", "test/app_root/db/migrate", "test/app_root/db/migrate/001_create_users.rb", "test/app_root/db/migrate/002_migrate_has_roles_to_version_4.rb", "test/app_root/config", "test/app_root/config/routes.rb", "test/app_root/config/environment.rb", "test/test_helper.rb", "test/functional", "test/functional/has_roles_test.rb", "test/functional/application_controller_test.rb", "CHANGELOG.rdoc", "init.rb", "LICENSE", "Rakefile", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://www.pluginaweek.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pluginaweek}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Demonstrates a reference implementation for handling role management in ActiveRecord}
  s.test_files = ["test/unit/role_test.rb", "test/unit/permission_test.rb", "test/unit/role_permission_test.rb", "test/unit/role_assignment_test.rb", "test/helpers/authorization_helper_test.rb", "test/helpers/url_helper_test.rb", "test/functional/has_roles_test.rb", "test/functional/application_controller_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<enumerate_by>, [">= 0.4.0"])
    else
      s.add_dependency(%q<enumerate_by>, [">= 0.4.0"])
    end
  else
    s.add_dependency(%q<enumerate_by>, [">= 0.4.0"])
  end
end
