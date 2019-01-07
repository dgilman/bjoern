FROM __DOCKER_TAG__

ADD . .

RUN set -x && \
    apt-get update && \
    apt-get install -y python-virtualenv python-dev python3-dev libev-dev build-essential && \
    virtualenv -p python2 venv2 && \
    virtualenv -p python3 venv3 && \
    venv2/bin/python -m pip install wheel && \
    venv3/bin/python -m pip install wheel && \
    for i in $(venv2/bin/python -m pip freeze | sed s/==.*//); do venv2/bin/python -m pip install -U $i; done && \
    for i in $(venv3/bin/python -m pip freeze | sed s/==.*//); do venv3/bin/python -m pip install -U $i; done && \
    venv2/bin/python setup.py bdist_wheel && \
    venv3/bin/python setup.py bdist_wheel && \
    ls -alh dist

ENTRYPOINT ["/bin/sh", "-c", "while true; do sleep 10; done"]
