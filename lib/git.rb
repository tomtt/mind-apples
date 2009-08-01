class Git
  def self.master_head_sha1
    unless File.exist?(filename = File.join(RAILS_ROOT, '.git', 'refs', 'heads', 'deploy'))
      filename = File.join(RAILS_ROOT, '.git', 'refs', 'heads', 'master')
    end
    File.read(filename)[0,7]
  end
end
