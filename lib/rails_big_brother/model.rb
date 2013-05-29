module RailsBigBrother
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def big_brother_watch(options = {})
        send :include, InstanceMethods

        class_attribute :big_brother_options
        self.big_brother_options = {}

        [:ignore, :only, :verbose].each do |k|
          self.big_brother_options[k] = [options[k]].flatten.compact.map(&:to_s) if options.has_key?(k)
        end

        after_create :log_create if !options[:on] || options[:on].include?(:create)
        before_update :log_update if !options[:on] || options[:on].include?(:update)
        after_destroy :log_destroy if !options[:on] || options[:on].include?(:destroy)
      end
    end

    module InstanceMethods
      private

      def log_create
        big_brother_log 'create'
      end

      def log_update
        changed_fields = self.changed
        changed_fields = changed_fields - self.class.big_brother_options[:ignore] if self.class.big_brother_options.has_key?(:ignore)
        changed_fields = changed_fields & self.class.big_brother_options[:only] if self.class.big_brother_options.has_key?(:only)

        unless changed_fields.empty?
          changed_fields_string = changed_fields.map do |f|
              f + (
                self.class.big_brother_options[:verbose].include?(f) ? ":#{send(f)}" : '')
            end.join(',')
          big_brother_log 'update', changed_fields_string
        end
      end

      def log_destroy
        big_brother_log 'destroy', to_s
      end

      def big_brother_log(action, *args)
        Rails.logger.info RailsBigBrother.format %
        {
          big_brother: "big_brother",
          user: RailsBigBrother.user,
          controller_info: RailsBigBrother.controller_info_string,
          class: self.class.name,
          id: self.to_param,
          action: action,
          args: args.join(',')
        }
      end
    end
  end
end
