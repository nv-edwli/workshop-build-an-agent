FROM nvcr.io/nvidia/rapidsai/notebooks:25.04-cuda12.8-py3.12

WORKDIR /opt/project/build/

USER $NVWB_USERNAME

WORKDIR /project

EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]