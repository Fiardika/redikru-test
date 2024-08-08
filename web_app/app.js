import express from 'express';
import prometheusMiddleware from 'express-prometheus-middleware';

const app = express();
const port = process.env.PORT || 3003; // Use the PORT environment variable provided by Heroku

// Use the Prometheus middleware
app.use(prometheusMiddleware({
  metricsPath: '/metrics',
  collectDefaultMetrics: true,
  requestDurationBuckets: [0.1, 0.5, 1, 1.5],
}));

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
