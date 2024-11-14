FROM denoland/deno:2.0.6
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /var/task
ADD deno.json .
ADD src/ .

RUN deno install

# this speeds up the invocation
RUN deno cache index.ts

CMD []