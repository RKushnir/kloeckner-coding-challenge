class DatabaseLock
  Timeout = Class.new(StandardError)

  def self.acquire(lock_id, timeout: 5, &block)
    connection = ActiveRecord::Base.connection.raw_connection

    ActiveRecord::Base.transaction do
      connection.exec("SET LOCAL lock_timeout = '#{timeout}s'");
      connection.exec("SELECT pg_advisory_lock($1)", [lock_id])
    end

    yield
  rescue PG::LockNotAvailable
    raise Timeout
  else
    connection.exec("SELECT pg_advisory_unlock($1)", [lock_id])
  end
end
