# frozen_string_literal: true

# * Puma can serve each request in a thread from an internal thread pool.
# * This behavior allows Puma to provide additional concurrency for your web application.
# * Loosely speaking, workers consume more RAM and threads consume more CPU, and both offer more concurrency.
# threads_count = Integer(ENV['MAX_THREADS'] || 5)
# threads threads_count, threads_count

# * Preloading your application reduces the startup time of individual Puma worker processes and
# * allows you to manage the external connections of each worker using the on_worker_boot calls.
# * In the config above, these calls are used to establish Postgres connections for each worker process correctly.
preload_app!
