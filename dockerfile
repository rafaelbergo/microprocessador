FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y ghdl gtkwave && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/vhdl

CMD ["bash"]
