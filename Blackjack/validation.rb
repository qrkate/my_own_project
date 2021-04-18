module Validation
  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end

  module ClassMethod
    attr_accessor :validates

    def validate(name, type, extra = nil)
      @validates ||= []
      @validates << { name: name, type: type, extra: extra }
    end
  end

  module InstanceMethod
    protected
    def validate!
      self.class.validates.each do |validation|
        value = instance_variable_get("@#{validation[:name]}".to_sym)
        method = "#{validation[:type]}".to_sym
        send(method, value, validation[:extra])
      end
    end

    def presence(value, extra)
      raise "Имя не может быть пустым." if value.nil? || value.empty?
    end

    def format(value, extra)
      raise "Неверный формат имени. Имя должно начинаться с большой буквы и содержать не менее двух букв." if value !~ extra
    end
  end
end
