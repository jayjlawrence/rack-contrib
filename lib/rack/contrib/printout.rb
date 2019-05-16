module Rack
  #prints the environment and request for simple debugging
  class Printout
    def initialize(app)
      @app = app
    end

    def logfile
      @logfile ||= ::File.join(::File.dirname(Rails.logger.instance_variable_get('@logger').instance_variable_get('@log_dest').path.to_s), "request_print.log")
    end

    def logfile_flag
      @logfile_flag ||= ::File.join(::File.dirname(Rails.logger.instance_variable_get('@logger').instance_variable_get('@log_dest').path.to_s), "request_print.log.stop")
    end

    def call(env)
      # See http://rack.rubyforge.org/doc/SPEC.html for details
      # Assume under Rails
      ::File.open(logfile, "at") do |file|
        file.puts "********** Environment #{env['action_dispatch.request_id']}\n#{env.inspect}"
      end unless ::File.exists?(logfile_flag)

      response = @app.call(env)

      ::File.open(logfile,"at") do |file|
        file.puts "********** Response #{env['action_dispatch.request_id']}\n#{response.inspect}\n**********\n Response contents #{env['action.dispatch.request_id']}#{response[2].respond_to?(:body) ? response[2].body.inspect : ''}\n\n"
      end unless ::File.exist?(logfile_flag)

      return response

    end
  end
end
