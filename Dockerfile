FROM python:3.13-slim as builder

WORKDIR /app

RUN apt-get update && \
		apt-get install -y --no-install-recommends python3-pip make && \
		rm -rf /var/lib/apt/lists/*

RUN python -m venv /app/venv


ENV PATH="/app/venv/bin:$PATH"
COPY pyproject.toml /app
COPY Makefile /app

RUN make

FROM python:3.13-slim

WORKDIR /app

RUN apt-get update && \
		apt-get install -y --no-install-recommends python3-pip make && \
		rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/venv /app/venv
COPY src /app/src
COPY --from=builder /app/Makefile /app/
COPY --from=builder /app/pyproject.toml /app/

ENV PATH="/app/venv/bin:$PATH"

CMD ["make", "run"]
