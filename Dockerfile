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
SHELL ["conda", "run", "--name", "app", "/bin/bash", "-c"]

# Define an entry-point for the docker image such that it execute the main.py python script of the application
ENTRYPOINT ["conda", "run", "--name", "app", "python", "main.py"]