FROM circleci/python:buster

WORKDIR /tmp

RUN curl -LO https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_Linux-64bit.deb
RUN sudo dpkg -i hugo_0.74.3_Linux-64bit.deb
RUN pip install awscli --upgrade --user