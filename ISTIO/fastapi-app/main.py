from fastapi import FastAPI
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk._logs import LoggingHandler
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.exporter.otlp.proto.http._log_exporter import OTLPLogExporter
import logging

# Setup logging
logger = logging.getLogger("uvicorn")
logger.setLevel(logging.INFO)

# OpenTelemetry tracer setup
provider = TracerProvider(resource=Resource.create({SERVICE_NAME: "fastapi-demo"}))
processor = BatchSpanProcessor(OTLPSpanExporter(endpoint="http://otel-collector:4318/v1/traces"))
provider.add_span_processor(processor)

# OpenTelemetry logs
log_processor = BatchLogRecordProcessor(OTLPLogExporter(endpoint="http://otel-collector:4318/v1/logs"))
logging.getLogger().addHandler(LoggingHandler(level=logging.INFO, logger=logger))
logger.addHandler(logging.StreamHandler())

from opentelemetry import trace
trace.set_tracer_provider(provider)
tracer = trace.get_tracer(__name__)

app = FastAPI()
FastAPIInstrumentor.instrument_app(app)

@app.get("/")
async def root():
    with tracer.start_as_current_span("root-span"):
        return {"message": "Hello from FastAPI with OpenTelemetry!"}