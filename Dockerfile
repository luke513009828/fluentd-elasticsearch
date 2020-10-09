FROM centos as builder

RUN yum install ruby -y && \
    yum install git -y && \
    git clone https://github.com/fluent/fluentd.git && \
    cd fluentd && \
    bundle install && \
    bundle exec rake build && \
    gem install pkg/fluentd-xxx.gem && \
    fluentd --setup ./fluent && \
    fluentd -c ./fluent/fluent.conf -vv && \
    echo '{"json":"message"}' | fluent-cat debug.test

# Expose prometheus metrics.
EXPOSE 80

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

# Start Fluentd to pick up our config that watches Docker container logs.
CMD ["/entrypoint.sh"]
