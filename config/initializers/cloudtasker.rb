host_file = Rails.root.join('config', 'host')

Cloudtasker.configure do |c|
  c.processor_host = (File.readable?(host_file) && File.read(host_file) || 'http://localhost:3000').chomp
  c.secret = ''
  c.gcp_location_id = 'asia-northeast1'
  c.gcp_project_id = ENV['PROJECT_ID']
end
