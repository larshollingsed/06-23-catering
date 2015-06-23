# Establish connection to the database
DB = SQLite3::Database.new("catering.db")

# Create tables (if they don't exist already)
DB.execute("CREATE TABLE IF NOT EXISTS employees (id INTEGER PRIMARY KEY, name TEXT, age INTEGER);")

DB.execute("CREATE TABLE IF NOT EXISTS events (id INTEGER PRIMARY KEY, name TEXT, date TEXT, hours NUMBER, hourly_wage NUMBER, gratuity NUMBER, alcohol TEXT);")

DB.execute("CREATE TABLE IF NOT EXISTS distributions (id INTEGER PRIMARY KEY, employee_id INTEGER, event_id INTEGER, manager TEXT);")

# Return results as an Array containing Hashes
DB.results_as_hash = true