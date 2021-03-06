import 'package:puppeteer/puppeteer.dart';


Future<void> test() async {
  // Download the Chromium binaries, launch it and connect to the "DevTools"
  var browser = await puppeteer.launch(headless: false);

  // Open a new tab
  var myPage = await browser.newPage();

  // Go to a page and wait to be fully loaded
  await myPage.goto('https://dart.dev', wait: Until.networkIdle);

  // Do something... See other examples
  await myPage.screenshot();
  await myPage.pdf();
  await myPage.evaluate('() => document.title');

  // Gracefully close the browser's process
  await browser.close();
}