# Use my general purpose dev env as the base image
FROM ryancollingham/dev_env:latest

# Set up a checkout of the Testplan repo.
RUN git clone https://github.com/Morgan-Stanley/testplan.git

# Install the Testplan package and its requirements in a development mode.
# We install the python dependencies for both python2 and 3 interpreters,
# since testplan is designed to be compatible with both versions.
RUN cd testplan && \
    . ~/.venv/py2/bin/activate && \
    pip install --no-cache-dir wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    deactivate && \
    . ~/.venv/py37/bin/activate && \
    pip install --no-cache-dir wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    ./install-testplan-ui --verbose --dev && \
    deactivate

# Install additional packages. Testplan requires rsync for some functionality.
RUN apt-get update && apt-get install -y rsync

