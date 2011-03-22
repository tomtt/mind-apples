module PostgresOnlyPend
  def pend_when_not_using_postgres
    pending "Spec disabled because it requires postgres" unless Person.connection.class.name == "ActiveRecord::ConnectionAdapters::PostgreSQLAdapter"
  end
end

