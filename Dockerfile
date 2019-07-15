FROM alpine:edge

MAINTAINER xujinkai <jack777@xujinkai.net>

RUN apk update && \
	apk add --no-cache --update bash && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	apk add --no-cache --update aria2 && \
	apk add git && \
        apk add coreutils && \
	apk add ruby && \
	apk add ruby-dev && \
        apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ ruby-unf_ext && \
        apk add ruby-json && \
	apk add ruby-nokogiri && \
        apk add ruby-bigdecimal && \
        apk add ruby-bundler && \
        apk add ncftp && \
	git clone https://github.com/ziahamza/webui-aria2 /aria2-webui && \
    rm /aria2-webui/.git* -rf && \
    apk del git && \
	apk add --update darkhttpd
	
ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf
ADD files/on-complete.sh /conf-copy/on-complete.sh
ADD files/ol-vid-up /bin/ol-vid-up
ADD files/a2-name /bin/a2-name
ADD files/a2-remove /bin/a2-remove
ADD Gemfile /aria2-webui/Gemfile

RUN chmod +x /conf-copy/start.sh && \
    chmod +x /bin/ol-vid-up && \
    chmod +x /bin/a2-* && \
    #ln -s /usr/lib/video-splitter/ffmpeg-split.py /bin/ && \
    #chmod +x /bin/ffmpeg-split.py && \
    bundle install --gemfile /aria2-webui/Gemfile

WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]
EXPOSE 6800
EXPOSE 8000
EXPOSE 8080

CMD ["/conf-copy/start.sh"]
