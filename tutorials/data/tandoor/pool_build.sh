#!/bin/zsh
cd /Users/faezs/ARTIST/tutorials
puffer_tandoor/.venv/bin/python tandoor_site_weather.py build --n 64 --years 2019 2022 --weight population --country PK --admin1 02 --admin1-share 0.67 --out data/tandoor/site_pool.json && \
puffer_tandoor/.venv/bin/python tandoor_site_weather.py urban data/tandoor/site_pool.json && echo POOL DONE
