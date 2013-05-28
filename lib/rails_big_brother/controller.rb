module RailsBigBrother
  module Controller
    def self.included(base)
      base.before_filter :set_log_current_user, :set_log_infos
    end

    protected

    def big_brother_user
      nil
    end

    def big_brother_infos
      {}
    end

    private

    def set_log_current_user
      ::RailsBigBrother.user = big_brother_user
    end

    def set_log_infos
      ::RailsBigBrother.controller_info = big_brother_infos
    end
  end
end
