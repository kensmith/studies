#!/usr/bin/env node

const puppeteer = require('puppeteer');

(async() => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://www.precisionrifleseries.com');
  const html = await page.content();
  console.log(html);
  await browser.close();
})();
