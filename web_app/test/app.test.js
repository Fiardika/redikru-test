const request = require('supertest');
const express = require('express');

const app = express();
app.get('/', (req, res) => {
  res.status(200).send('Hello World!');
});

describe('GET /', function() {
  it('responds with Hello World!', function(done) {
    request(app)
      .get('/')
      .expect(200)
      .expect('Hello World!', done);
  });
});
