namespace :maintenance do

  task :enable, :roles => :web do
    require 'erb'
    on_rollback { run "rm -f #{shared_path}/system/#{maintenance_basename}.html" }

    reason = ENV['REASON']
    deadline = ENV['UNTIL']

    template = File.read(maintenance_template_path)
    result = ERB.new(template).result(binding)

    upload! result, "#{shared_path}/system/#{maintenance_basename}.html", :mode => 0644
  end

  task :disable, :roles => :web do
    execute "rm", "-f", "#{shared_path}/system/#{maintenance_basename}.html"
  end
end
