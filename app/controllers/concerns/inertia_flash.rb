module InertiaFlash
  extend ActiveSupport::Concern

  included do
    inertia_share do
      {
        has_flash: !flash.empty?,
        flash: flash.to_hash,
      }
    end
  end
end