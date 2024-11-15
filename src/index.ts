import { Hono } from "hono";
const app = new Hono();

app.get("/", (c) => c.text("Hono!"));

app.post("/events", async (c) => {
  console.log(c);

  const body = await c.req.parseBody();
  return c.json(body);
});

export default app;
