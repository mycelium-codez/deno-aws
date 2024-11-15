import { Hono } from "hono";
const app = new Hono();

app.get("/", (c) => c.text("Hello lambda!"));

// events will be directed to /events ➡️ configured via AWS_LWA_PASS_THROUGH_PATH
app.post("/events", async (c) => {
  const req = {
    headers: c.req.header(),
    text: await c.req.text(),
    json: await c.req.json(),
  };

  console.log(req);

  return req.json;
});

export default app;
