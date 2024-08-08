const express = require('express');
const prometheusMiddleware = require('express-prometheus-middleware');

const app = express();
const port = 3003;

// Use the prometheus middleware
app.use(prometheusMiddleware({
  metricsPath: '/metrics',
  collectDefaultMetrics: true,
  requestDurationBuckets: [0.1, 0.5, 1, 1.5],
}));

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Example app listening at http://0.0.0.0:${port}`);
});
