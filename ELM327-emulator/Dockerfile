FROM python:3.15-slim
RUN pip install --no-cache-dir ELM327-emulator
EXPOSE 35000
CMD ["python3", "-m", "elm", "-n", "35000", "-i", "0.0.0.0", "-s", "car"]
