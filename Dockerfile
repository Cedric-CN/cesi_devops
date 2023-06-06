FROM node:alpine
RUN apk update
RUN apk add openrc openssh
RUN rc-status \
    # touch softlevel because system was initialized without openrc
    && touch /run/openrc/softlevel \
    && rc-service sshd start \
    && echo -e "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel
RUN apk add git
RUN service sshd restart

# create & set working directory
RUN mkdir -p /usr/src
WORKDIR /usr/src

# copy source files
COPY . /usr/src

# install dependencies
RUN npm install

# start app
RUN npm run build
EXPOSE 3000
CMD npm run start
