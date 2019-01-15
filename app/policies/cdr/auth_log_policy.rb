# frozen_string_literal: true

module Cdr
  class AuthLogPolicy < ::RolePolicy
    section 'Cdr/AuthLog'

    class Scope < ::RolePolicy::Scope
    end
  end
end
