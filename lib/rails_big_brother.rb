require "rails_big_brother/version"
require "rails_big_brother/controller"
require "rails_big_brother/model"

module RailsBigBrother
  def user=(value)
    store[:user] = value
  end

  def user
    store[:user]
  end

  def controller_info=(value)
    store[:controller_info] = value
  end

  def controller_info
    store[:controller_info]
  end

  def controller_info_string
    case controller_info
    when Array
      controller_info.join(',')
    when Hash
      controller_info.map { |k,v| "#{k}:#{v}" }.join(',')
    else
      controller_info
    end
  end

  private

  def store
    Thread.current[:big_brother_log] ||= {}
  end

  extend self
end

ActiveSupport.on_load(:active_record) do
  include RailsBigBrother::Model
end

ActiveSupport.on_load(:action_controller) do
  include RailsBigBrother::Controller
end
