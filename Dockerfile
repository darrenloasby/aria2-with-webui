FROM alpine:edge

MAINTAINER xujinkai <jack777@xujinkai.net>


RUN apk update && \
	apk add --no-cache --update bash && \
	mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	apk add --no-cache --update aria2 && \
	apk add git && \
	apk add python3 && \
	apk add python3-dev && \
	apk add ffmpeg && \
	apk add ruby && \
	apk add ruby-dev && \
	apk add ruby-bundler && \
	git clone https://github.com/ziahamza/webui-aria2 /aria2-webui && \
	git clone https://github.com/c0decracker/video-splitter.git /usr/lib/video-splitter && \
    rm /aria2-webui/.git* -rf && \
    rm /usr/lib/video-splitter/.git* -rf && \
    rm /usr/lib/video-splitter/examples -rf && \
    apk del git && \
	apk add --update darkhttpd
	
ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf
ADD files/on-complete.sh /conf-copy/on-complete.sh
ADD Gemfile /aria2-webui/Gemfile

RUN chmod +x /conf-copy/start.sh && \
    ln -s -t /bin/ /usr/lib/video-splitter/ffmpeg-split.py && \
    chmod +x /bin/ffmpeg-split.py && \
    bundle install --gemfile /aria2-webui/Gemfile

WORKDIR /
VOLUME ["/data"]
VOLUME ["/conf"]
EXPOSE 6800
EXPOSE 8000
EXPOSE 8080

CMD ["/conf-copy/start.sh"]
