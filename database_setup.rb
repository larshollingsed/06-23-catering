# Establish connection to the database
DB = SQLite3::Database.new("catering.db")

# Create tables (if they don't exist already)
DB.execute("CREATE TABLE IF NOT EXISTS employees (id INTEGER PRIMARY KEY, name TEXT, age INTEGER);")

# Return results as an Array containing Hashes
DB.results_as_hash = true