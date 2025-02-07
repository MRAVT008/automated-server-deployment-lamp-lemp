import os
import subprocess

LOG_FILE = "/var/log/mysql_setup.log"

def log(message):
    with open(LOG_FILE, "a") as log_file:
        log_file.write(f"{message}\n")
    print(message)

def setup_mysql(root_password, db_name, db_user, db_password):
    try:
        # Secure MySQL installation
        os.system(f"mysql_secure_installation <<< '{root_password}\\nY\\nY\\nY\\nY\\n'")

        # Create database and user
        sql_commands = f"""
        CREATE DATABASE {db_name};
        CREATE USER '{db_user}'@'localhost' IDENTIFIED BY '{db_password}';
        GRANT ALL PRIVILEGES ON {db_name}.* TO '{db_user}'@'localhost';
        FLUSH PRIVILEGES;
        """
        subprocess.run(["mysql", "-u", "root", "-p"+root_password, "-e", sql_commands], check=True)
        
        log("✅ MySQL database & user created successfully!")
    except Exception as e:
        log(f"❌ MySQL setup failed: {str(e)}")

if __name__ == "__main__":
    setup_mysql("RootPass123", "mydatabase", "myuser", "UserPass123")
