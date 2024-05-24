# Use the official Python image from the Docker Hub
FROM python:3.10-buster

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install netcat-openbsd
RUN apt-get update && apt-get install -y netcat-openbsd

# Make the wait-for-it.sh script executable
RUN chmod +x wait-for-it.sh

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run the wait-for-it script and then the application
CMD ["./wait-for-it.sh", "db:5432", "--", "python", "main.py"]
