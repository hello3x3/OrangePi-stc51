FROM ubuntu

LABEL maintainer="shujiuhe <shujiuhe@outlook.com>"

SHELL [ "/bin/bash", "--login", "-c" ]

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install sdcc python3 python3-serial python3-tqdm -y --no-install-recommends

COPY --chown=root:root flash /usr/local/bin/flash
COPY --chown=root:root stcgal/ /usr/local/stcgal/

RUN chmod +x /usr/local/bin/flash

