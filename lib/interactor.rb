require "interactor/context"
require "interactor/error"
require "interactor/organizer"

module Interactor
  def self.included(base)
    base.class_eval do
      extend ClassMethods

      attr_reader :context
    end
  end

  module ClassMethods
    def perform(context = {})
      new(context).tap(&:run)
    end
  end

  def initialize(context = {})
    @context = Context.build(context)
  end

  def run
    setup
    perform
  rescue Failure
  end

  def setup
  end

  def perform
  end

  def rollback
  end

  def success?
    context.success?
  end

  def failure?
    context.failure?
  end

  def fail!(*args)
    context.fail!(*args)
    raise Failure
  end

  def method_missing(method, *)
    context.fetch(method) { context.fetch(method.to_s) { super } }
  end

  def respond_to_missing?(method, *)
    (context && (context.key?(method) || context.key?(method.to_s))) || super
  end
end
