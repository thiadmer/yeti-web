# frozen_string_literal: true

module System
  class CountryPolicy < ::RolePolicy
    section 'System/Country'

    class Scope < ::RolePolicy::Scope
    end
  end
end
