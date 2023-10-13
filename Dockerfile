# Use an official Anaconda runtime as a parent image
FROM continuumio/anaconda3
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

# Add activate to bash so conda can actually do things
SHELL ["source","/etc/profile.d/conda.sh"]

# Activate the conda environment
SHELL ["conda", "activate", "housing"]

# Run the python script
SHELL ["python", "/app/create_model.py"]

# Open ports
EXPOSE 80 5000
