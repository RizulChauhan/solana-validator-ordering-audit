FROM python:3.11-slim

WORKDIR /app

# Non-root user for security
RUN useradd -m -u 1000 appuser

COPY . /app

RUN chown -R appuser:appuser /app

USER appuser

ENTRYPOINT ["python3", "main.py"]
CMD ["--dry-run", "--samples", "6"]
