#!/bin/bash

poetry run dj collectstatic --noinput
poetry run dj migrate
"$@"
