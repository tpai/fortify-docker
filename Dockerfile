FROM ubuntu:22.04 AS base

WORKDIR /fortify

COPY Fortify_SCA_23.1.0_linux_x64.run /fortify
COPY Fortify_Apps_and_Tools_23.1.0_linux_x64.run /fortify
COPY fortify.license /fortify

RUN ./Fortify_SCA_23.1.0_linux_x64.run --mode unattended
RUN ./Fortify_Apps_and_Tools_23.1.0_linux_x64.run --mode unattended

RUN /opt/Fortify/Fortify_SCA_23.1.0/bin/fortifyupdate

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y fonts-dejavu x11-apps

COPY --from=base /opt/Fortify /opt/Fortify

ENV PATH="/opt/Fortify/Fortify_SCA_23.1.0/bin:/opt/Fortify/Fortify_Apps_and_Tools_23.1.0/bin:${PATH}"
