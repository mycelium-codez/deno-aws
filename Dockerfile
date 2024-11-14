FROM public.ecr.aws/lambda/provided:al2

COPY --from=denoland/deno:bin-2.0.6 /deno /usr/local/bin/deno

#USER deno

WORKDIR /app

COPY src/ .
COPY deno.json .

RUN deno install

CMD []