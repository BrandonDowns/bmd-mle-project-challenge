# Use an official Anaconda runtime as a parent image
FROM continuumio/anaconda3
LABEL authors="BrandonDowns"

# Set the working directory in the container to /app
WORKDIR /app

#install node
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Add the current directory contents into the container at /app
ADD . /app

# Install json dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
# Bundle app source
COPY . .

RUN npm install
# Update Conda
RUN conda update --name base conda

# Create a Conda environment and install the pip packages defined in YAML file
RUN conda env create --file conda_environment.yml

#we need bash for conda stuff
SHELL ["/bin/bash", "-c"]

# Edit the shell command so we can launch python scripts from within the newly created conda environment
# This isn't strictly necessary, but is likely good for consistency
RUN ["conda", "run", "--name", "housing", "/bin/bash", "-c"]

# Add activate to bash so conda can actually do things
RUN ["source","/etc/profile.d/conda.sh"]

# Activate the conda environment
RUN ["conda", "activate", "housing"]

# Run the python script
RUN python /app/create_model.py

# Open ports
EXPOSE 80 5000 8080
CMD [ "node", "app.js" ]
