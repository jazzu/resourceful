task :default => ["test"]

task :test do
  FileList["test/test_*"].each do |test_file|
    ruby "#{test_file}"
  end
end
