# `python-base` sets up all our shared environment variables
FROM python:3.11-slim-bullseye as python-base

WORKDIR /app

RUN apt-get update

RUN apt-get install -y python3-pip
RUN apt-get install -y libssl-dev

COPY . .

RUN pip install -U poetry
RUN /bin/true\
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --without dev \
    && rm -rf /root/.cache/pypoetry



# `development` image is used during development / testing
FROM python-base as development

# quicker install as runtime deps are already installed
RUN poetry install --with dev

ENTRYPOINT ["/app/entrypoint.sh"]



# creating open api schema
FROM python-base as rapidoc

# RUN poetry install --with docs

ENV DJANGO_SETTINGS_MODULE=src.settings.spectacular

RUN ["poetry", "run", "dj", "spectacular", "--file", "schema.yml"]

FROM mrin9/rapidoc as docs

COPY --from=rapidoc /app/schema.yml /usr/share/nginx/html/schema.yml

ENV PAGE_TITLE="API Docs"
ENV SPEC_URL="schema.yml"



# `production` image used for runtime
FROM python-base as production

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["poetry", "run", "gunicorn", "src.config.wsgi:application", \
    "-w", "4", \
    "-b", "0.0.0.0:8000", \
    "--error-logfile", "-", \
    "--enable-stdio-inheritance", \
    "--log-level", "debug"]
