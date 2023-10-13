# Use an official Anaconda runtime as a parent image
FROM continuumio/miniconda3
LABEL authors="BrandonDowns"

# Set the working directory in the container to /app
WORKDIR /app

# Add the current directory contents into the container at /app
ADD . /app

# Update Conda
RUN conda update --name base conda

# Create a Conda environment and install the pip packages defined in YAML file
RUN conda env create --file conda_environment.yml

# Edit the shell command so we can launch python scripts from within the newly created conda environment
# This isn't strictly necessary, but is likely good for consistency
SHELL ["conda", "run", "--name", "housing", "/bin/bash", "-c"]

# Activate the conda environment
SHELL ["conda", "activate", "housing"]

# Define an entry-point for the docker image such that it executes the main.py python script of the application
ENTRYPOINT ["conda", "run", "--name", "housing", "python", "create_model.py"]

# Open ports
EXPOSE 80 5000
