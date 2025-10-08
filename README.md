## Step 11 — Reflection Questions

### Concept Check

**Q:** What is the difference between a route inside Flutter and a deep link at the Android level?  
A route inside Flutter is a navigation path defined within the app (e.g., `Navigator.pushNamed('/details')`). A deep link at the Android level is an external URL that instructs Android to open a specific screen in the app from outside, such as a browser or another app. Deep links require Android to detect and route them before Flutter handles them.

**Q:** Why does Android need an intent filter?  
Android uses intent filters in the manifest to identify which apps can handle certain actions or URL schemes. For deep linking, intent filters allow Android to detect the custom scheme (e.g., `myapp://`) and pass the link to the correct app.

---

### Technical Understanding

**Q:** Explain the role of the `app_links` package.  
The `app_links` package lets Flutter apps capture incoming deep links and route them within the app. It provides `getInitialUri()` for cold starts and `uriLinkStream` for handling live link updates while the app is running.

**Q:** What happens if a deep link is opened while the app is already running?  
The `uriLinkStream` listener captures the new link without restarting the app, allowing navigation to the appropriate screen instantly.

---

### Debugging Insight

**Q:** Suppose your adb command opens the app but it doesn’t navigate to the detail page. What part of your code or manifest would you check first, and why?  
1. **AndroidManifest.xml** — ensure the intent filter matches the custom scheme and host exactly.  
2. **Link handling code** — check that `_handleIncomingLink` is parsing the URI correctly and triggering navigation.  
3. **app_links setup** — confirm that `initAppLinks()` is called in `initState()` and that `uriLinkStream` is subscribed.

## Step 13 — Wrap-Up Summary

Deep linking integrates Flutter navigation with Android intent filters by allowing external URLs to directly open specific screens inside a Flutter app. At the Android level, the intent filter registers the app to handle certain URL schemes, while Flutter uses packages like `app_links` to parse and route these links internally.

One practical scenario for deep linking is in authentication flows — for example, after a user verifies their email, a link can directly open the relevant screen inside the app instead of the home page.

The most challenging part of this lab was correctly setting up the intent filter in `AndroidManifest.xml` and ensuring `app_links` correctly handled both cold start and live link events. This was resolved by carefully following the deep linking configuration steps and testing with adb commands to verify the expected behavior.
