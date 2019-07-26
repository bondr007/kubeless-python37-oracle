FROM debian AS client
ARG ORACLE_VERSION=19.3.0.0.0dbru
ARG ORACLE_ZIP_INTERNAL_FOLDER=instantclient_19_3
WORKDIR /root
ENV CLIENT_ZIP=instantclient-basiclite-linux.x64-${ORACLE_VERSION}.zip
ENV SDK_ZIP=instantclient-sdk-linux.x64-${ORACLE_VERSION}.zip

RUN apt-get update && apt-get -yq install unzip
COPY ${CLIENT_ZIP} .
COPY ${SDK_ZIP} .
RUN unzip ${CLIENT_ZIP}
RUN unzip ${SDK_ZIP}
RUN mv ${ORACLE_ZIP_INTERNAL_FOLDER} oracle
RUN rm ${CLIENT_ZIP} ${SDK_ZIP}

# switch over to Kubeless image
FROM kubeless/python:3.7
USER root
# Configure apt and install packages
RUN apt-get update && apt-get install -y libaio1\
     && rm -rf /var/lib/apt/lists/*


#############
# copy the built files for oracle client
#############
ENV HOME /root
ENV ORACLE_HOME /opt/oracle
ENV TNS_ADMIN ${ORACLE_HOME}/network/admin
ENV ORACLE_VERSION=19.3.0.0.0dbru
COPY --from=client /root/oracle ${ORACLE_HOME}
	# Install Oracle Instant Client
RUN echo ${ORACLE_HOME} > /etc/ld.so.conf.d/oracle.conf \
	&& mkdir -p ${TNS_ADMIN} \
	&& ldconfig

USER 1000