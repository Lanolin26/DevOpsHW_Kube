FROM python:3.9-alpine

ARG UID=1001
ARG author=Artem Kiselev <lanolin652@gmail.com>
ARG version=1

LABEL org.opencontainers.image.version=${version}
LABEL org.opencontainers.image.authors=${author}

USER ${UID}

WORKDIR /app

COPY --chown=${UID} app/helloworld ./helloworld

EXPOSE 8000

CMD [ "python3", "-m", "http.server", "8000" ]