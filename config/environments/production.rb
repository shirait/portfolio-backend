require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false

  config.eager_load = true

  config.consider_all_requests_local = false

  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.active_storage.service = :local

  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.silence_healthcheck_path = "/up"

  config.active_support.report_deprecations = false

  # DBホスティングサービスは supabase を利用。supabaseは1プロジェクト1DBのため、キャッシュは solid_cache ではなくメモリに保存する。
  config.cache_store = :memory_store

  # DBホスティングサービスは supabase を利用。supabaseは1プロジェクト1DBのため、ジョブキューは solid_queue ではなくメモリに保存する。
  config.active_job.queue_adapter = :async

  # solid_queue が使用するDBを指定。今回はdbではなく async を利用するためコメントアウト。
  # config.solid_queue.connects_to = { database: { writing: :queue } }

  # メール送信機能無し。
  # config.action_mailer.default_url_options = { host: "example.com" }

  config.i18n.fallbacks = true

  config.active_record.dump_schema_after_migration = false

  config.active_record.attributes_for_inspect = [ :id ]

  config.assume_ssl = true
  config.force_ssl = true
  # config.hosts << ENV.fetch("RENDER_EXTERNAL_HOSTNAME")
end
