
template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "debian.postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end


template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql"), :immediately
end

bash "create-postgres-database" do
  user 'postgres'
  code <<-EOH
echo "CREATE DATABASE werckerdb1;" | psql
  EOH
  #not_if do
  #  begin
  #    require 'rubygems'
  #    Gem.clear_paths
  #    require 'pg'
  #    conn = PGconn.connect("localhost", 5432, nil, nil, nil, "postgres", node['postgresql']['password']['postgres'])
  #  rescue PGError
  #    false
  #  end
  #end
  action :run
end
