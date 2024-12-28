FROM ubuntu

LABEL maintainer="shujiuhe <shujiuhe@outlook.com>"

SHELL [ "/bin/bash", "--login", "-c" ]

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install sdcc python3 python3-serial python3-tqdm -y --no-install-recommends

COPY --chown=root:root flash.sh /usr/local/bin/flash.sh
COPY --chown=root:root stcgal/ /usr/local/stcgal/

RUN chmod +x /usr/local/bin/flash.sh && \
    mv /usr/local/bin/flash.sh /usr/local/bin/flash && \
    mkdir -p /root/stc51/ && \
    echo "cd /root/stc51/" >> /root/.bashrc

