require 'rake'
require 'rake/tasklib'

module Spectifly
  class Task < ::Rake::TaskLib
    attr_accessor :config_path

    def initialize(task_name, *args, &block)
      @stuff = 'default stuff'
      task task_name, *args do |task_name, task_args|
        block.call(self) if block
        puts "This is #{task_name} task with #{config_path}"
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), '..', 'tasks', '*.rake')].each do |path|
  load path
end