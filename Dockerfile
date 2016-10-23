FROM python:3

# Set correct environment variables
ENV HOME /root
WORKDIR /work

# Use baseimage-dockers init system
CMD ["/sbin/my_init"]

RUN apt-get -q update --fix-missing
RUN apt-get -qy upgrade

# Dependencies
RUN apt-get -qy install supervisor git curl

RUN pip install requests
RUN pip install requests[security]			###???
RUN pip install requests-cache
RUN pip install babelfish
RUN pip install 'guessit<2'
RUN pip install 'subliminal<2'
RUN pip install stevedore
RUN pip install python-dateutil
# pip install deluge-client
RUN pip install qtfaststart


WORKDIR /work

# Get MP4Automator
RUN git clone git://github.com/mdhiggins/sickbeard_mp4_automator.git /mp4automator

# Use .ini if present or copy sample
RUN cp /mp4automator/autoProcess.ini.sample /mp4automator/autoProcess.ini

# Copy over ffmpeg
COPY ffmpeg /work/ffmpeg
COPY ffprobe /work/ffprobe
COPY ffserver /work/ffserver

# Install Configs
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /work/supervisord.conf

VOLUME ["/config", "/storage", "/incoming"]

CMD [ "-c", "/work/supervisord.conf"]
ENTRYPOINT ["/usr/bin/supervisord"]
