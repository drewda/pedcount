require 'guard/guard'

module ::Guard
  class Middleman < ::Guard::Guard
    def run_all
      system("bundle exec middleman build --clean")
    end

    def run_on_change(paths)
	    UI.info "Noticed changes to /source, so now we're doing a Middleman build"
      system("bundle exec middleman build --clean")
      UI.info "Middleman is done building"
      Notifier.notify "Middleman is done building"
    end
  end
end

guard 'middleman' do
  watch(/^source/)
end
