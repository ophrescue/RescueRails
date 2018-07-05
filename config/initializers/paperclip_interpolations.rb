module Paperclip
  module Interpolations
    def paperclip_production_path(attachment, style_name)
      storage_path(attachment, :production)
    end

    def paperclip_test_path(attachment, style_name)
      storage_path(attachment, :test)
    end

    def paperclip_staging_path(attachment, style_name)
      storage_path(attachment, :staging)
    end

    private

    def storage_path(attachment, env)
      attachment.instance.class.const_get(:PAPERCLIP_STORAGE_PATH)[env]
    end
  end
end
