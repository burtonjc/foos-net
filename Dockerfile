FROM quay.io/rallysoftware/nodejs:0.10.32

EXPOSE 8080
RUN mkdir /foosnet
ADD . /foosnet
RUN npm install -g grunt-cli
RUN yum -y install ruby rubygems && gem install --no-ri --no-rdoc sass
WORKDIR /foosnet
RUN npm install
CMD grunt build node:run
