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
          self.big_brother_options[k] = (
            options[k] == true || options[k] == false ? options[k] : [options[k]].flatten.compact.map(&:to_s)
          ) if options.has_key?(k)
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
        options = self.class.big_brother_options

        changed_fields = self.changed
        # Remove fields from :ignore array
        changed_fields = changed_fields -
          options[:ignore] if options.has_key?(:ignore) && options[:ignore].is_a?(Array)
        # Keep only fields from :only array
        changed_fields = changed_fields &
          options[:only] if options.has_key?(:only) && options[:only].is_a?(Array)

        unless changed_fields.empty?
          verbose = options[:verbose] if options.has_key?(:verbose)

          fields_hash = changed_fields.inject({}) do |hash, field|
            hash[field] = (
              (verbose.is_a?(Array) && verbose.include?(field)) ||
                verbose == true ? send(field).to_s : ''
            )

            hash
          end
          big_brother_log 'update', RailsBigBrother.hash_to_s.call(fields_hash)
        end
      end

      def log_destroy
        big_brother_log 'destroy', to_s
      end

      def big_brother_log(action, *args)
        RailsBigBrother.logger.info RailsBigBrother.format %
        {
          user: RailsBigBrother.user,
          controller_info: RailsBigBrother.controller_info_string,
          class: self.class.name,
          id: self.to_param,
          action: action,
          args: RailsBigBrother.array_to_s.call(args)
        }
      end
    end
  end
end
