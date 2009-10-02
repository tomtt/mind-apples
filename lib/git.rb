class Git
  def self.master_head_sha1
    filename = File.join(RAILS_ROOT, '.git', 'refs', 'heads', 'deploy')
    unless File.exist?(filename)
      filename = File.join(RAILS_ROOT, '.git', 'refs', 'heads', 'master')
    end

    if File.exist?(filename)
      File.read(filename)[0,7]
    else
      "Git head unknown"
    end
  end
end
