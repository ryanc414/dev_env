# Use my general purpose dev env as the base image 
FROM ryancollingham/dev_env:latest 

# Set up a checkout of the Testplan repo. We checkout the fork but set master
# to track from the upstream. Set up github username and email for my MS
# account.
RUN git clone https://github.com/ryan-collingham/testplan.git && \
    cd testplan && \
    git remote add upstream https://github.com/Morgan-Stanley/testplan.git && \
    git fetch upstream && \
    git branch -u upstream/master && \
    git config user.name ryan-collingham && \
    git config user.email 43373633+ryan-collingham@users.noreply.github.com
  
# Install the Testplan package and its requirements in a development mode.
# We install the python dependencies for both python2 and 3 interpreters,
# since testplan is designed to be compatible with both versions.
RUN cd testplan && \
    python3.7 -m pip install -r requirements.txt && \
    python2 -m pip install -r requirements.txt && \
    ./install-testplan-ui --verbose --dev

# Install additional packages. Testplan requires rsync for some functionality.
RUN apt-get update && apt-get install -y rsync

