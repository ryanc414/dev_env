# Use my general purpose dev env as the base image 
FROM ryancollingham/dev_env:latest 

# Set up a checkout of the Testplan repo. We checkout the fork but set master
# to track from the upstream.
RUN git clone https://github.com/ryan-collingham/testplan.git && \
    cd testplan && \
    git remote add upstream https://github.com/Morgan-Stanley/testplan.git && \
    git fetch upstream && \
    git branch -u upstream/master
  
# Install the Testplan package and its requirements in a development mode.
RUN cd testplan && \
    pip install -r requirements.txt && \
    python setup.py develop && \
    ./install-testplan-ui --verbose --dev
    
