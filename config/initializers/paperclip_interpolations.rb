module Paperclip
  module Interpolations
    def paperclip_production_path(attachment, style_name)
      storage_path(attachment, :production)
    end

    def paperclip_test_path(attachment, style_name)
      # Each parallel_tests worker gets its own subdirectory (TEST_ENV_NUMBER
      # is "", "2", "3", ... per worker) so concurrent specs asserting on
      # file counts in this directory don't see each other's uploads.
      storage_path(attachment, :test).sub('/system/test/', "/system/test#{ENV['TEST_ENV_NUMBER']}/")
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
