require "fileutils"

module JMandy
  class Packer
    TMP_DIR = '/tmp/jmandy'
    MANDY_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    
    def self.pack
      tmp_path = "#{TMP_DIR}/packed-job-#{Time.now.to_i}-#{Process.pid}"
      FileUtils.mkdir_p(tmp_path)
      FileUtils.cp_r(Dir.glob(File.join(MANDY_DIR, 'lib', '*')), tmp_path)
      Dir.chdir(tmp_path) { `tar -czf bundle.tar *` }
      File.join(tmp_path, 'bundle.tar')
    end
    
    def self.cleanup!(file)
      return false unless File.extname(file) == '.tar'
      FileUtils.rm_rf(File.dirname(file))
    end
  end
end