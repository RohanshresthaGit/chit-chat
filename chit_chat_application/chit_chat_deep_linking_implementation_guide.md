# Chit Chat Flutter Deep Linking --- Implementation Guide

This guide documents how to configure **Chit Chat** so a link can open
the app directly to a particular screen or conversation.

It is written for later implementation. You do **not** need to change
anything now. Follow the steps in order when you are ready.

The examples use the domain:

`https://rohan-shrestha.info.np`

The Flutter app already uses GoRouter and has routes such as:

-   `/chats`
-   `/chats/:chatId`
-   `/friends`
-   `/settings`

> **Important:** Replace every placeholder such as
> `YOUR_ANDROID_APPLICATION_ID`, `YOUR_SHA256_FINGERPRINT`,
> `YOUR_IOS_BUNDLE_ID`, and `YOUR_APPLE_TEAM_ID` with the real values
> from your project. Do not copy placeholder values into production.

------------------------------------------------------------------------

# Part 1 --- Understand the pieces

Deep linking involves three separate parts:

1.  **The website/domain** proves that your domain is allowed to open
    your app.
2.  **Android and iOS configuration** tells the operating system which
    links belong to Chit Chat.
3.  **Flutter/GoRouter** receives the URL and displays the matching
    route.

For example, someone taps:

`https://rohan-shrestha.info.np/chats/101`

If Chit Chat is installed and the platform association is configured
correctly, the operating system opens Chit Chat. GoRouter then matches
`/chats/101` and displays the conversation screen.

If the app is not installed, the URL opens in the browser. You can later
add a website fallback page that explains how to install the app.

## The two link types

### HTTPS App Links / Universal Links --- recommended

Examples:

``` text
https://rohan-shrestha.info.np/chats
https://rohan-shrestha.info.np/chats/101
https://rohan-shrestha.info.np/friends
```

-   Android calls these **App Links**.
-   Apple calls these **Universal Links**.
-   They use your existing domain.
-   They are the recommended links to share with users.

### Custom URL scheme --- optional

Example:

``` text
chitchat:///chats/101
```

A custom scheme can be useful for development or integrations, but it
does not provide the same verified-domain guarantee as HTTPS App
Links/Universal Links. Prefer HTTPS links when sharing links publicly.

The triple slash in this example is intentional: it keeps `/chats/101`
as the URL path. A URL such as `chitchat://chats/101` parses `chats` as
the host, which may not match the route path expected by GoRouter
without extra handling.

------------------------------------------------------------------------

# Part 2 --- Step-by-step implementation

# Step 1 --- Confirm the Flutter route paths

Before configuring the operating systems, make sure GoRouter has routes
matching the URLs you intend to open.

Your route paths should conceptually look like this:

  Screen         Route path
  -------------- ------------------
  Chats list     `/chats`
  Chat details   `/chats/:chatId`
  Friends        `/friends`
  Settings       `/settings`

The chat details route uses a path parameter. For example, `/chats/101`
supplies `101` as `chatId`.

Example route:

``` dart
GoRoute(
  path: '/chats/:chatId',
  name: 'chatDetails',
  pageBuilder: (context, state) {
    final chatId = state.pathParameters['chatId']!;

    return RouteTransitions.slide(
      key: state.pageKey,
      child: ChatDetailsPage(chatId: chatId),
    );
  },
),
```

**Explanation**

-   `:chatId` means that part of the URL is dynamic.
-   `state.pathParameters['chatId']` reads the value from the incoming
    URL.
-   `RouteTransitions.slide` reuses the transition helper already
    present in the project.
-   The incoming URL `/chats/101` therefore opens
    `ChatDetailsPage(chatId: '101')`.

Keep the actual route definitions in your existing `app_router.dart`; do
not create a second router just for deep links.

------------------------------------------------------------------------

# Step 2 --- Prepare the website's association-file directory

Your portfolio is a Next.js website hosted at:

`https://rohan-shrestha.info.np`

For a typical Next.js project, files placed in its `public` directory
are served from the website root.

Create this directory:

``` text
public/
└── .well-known/
```

You will eventually place two platform association files inside it:

``` text
public/
└── .well-known/
    ├── assetlinks.json
    └── apple-app-site-association
```

**Explanation**

These files are not ordinary web pages. Android and Apple fetch them
directly to verify that your app is authorized to handle links from your
domain.

After deployment, the files must be reachable at these exact addresses:

``` text
https://rohan-shrestha.info.np/.well-known/assetlinks.json
https://rohan-shrestha.info.np/.well-known/apple-app-site-association
```

Requirements:

-   Use HTTPS.
-   Serve the files directly without redirects.
-   Do not add `.json` to `apple-app-site-association`.
-   Make sure the deployed website actually serves the files from those
    exact paths.

You can create the directory now, but the final file contents depend on
the identifiers collected in the next steps.

------------------------------------------------------------------------

# Step 3 --- Find the Android application ID

Open the Flutter project's Android Gradle configuration.

Depending on the project, it is usually one of:

``` text
android/app/build.gradle
android/app/build.gradle.kts
```

Look for `applicationId`.

Groovy example:

``` gradle
android {
    defaultConfig {
        applicationId "com.example.chit_chat_application"
    }
}
```

Kotlin DSL example:

``` kotlin
android {
    defaultConfig {
        applicationId = "com.example.chit_chat_application"
    }
}
```

**Explanation**

The application ID uniquely identifies the Android app. Android uses it
in `assetlinks.json` and in the manifest configuration.

Do not assume the example value is your actual ID. Copy the value from
your project.

Record it:

``` text
YOUR_ANDROID_APPLICATION_ID
```

------------------------------------------------------------------------

# Step 4 --- Get the Android SHA-256 signing fingerprint

Android verifies not only the application ID but also the certificate
used to sign the app.

From the Flutter project, run:

``` bash
cd android
./gradlew signingReport
```

On Windows, use:

``` powershell
cd android
.\gradlew signingReport
```

Find the relevant variant (usually `debug` for local testing) and copy
its `SHA-256` fingerprint.

It looks similar to:

``` text
AA:BB:CC:DD:...:11:22
```

**Explanation**

-   The debug certificate is suitable for testing a locally installed
    debug build.
-   A release build may use a different certificate.
-   If the app is distributed through Google Play App Signing, use the
    **App signing key certificate** fingerprint shown in Play Console
    for the published app.
-   You can include more than one fingerprint in `assetlinks.json`, for
    example the debug fingerprint and the Play App Signing fingerprint.

Record the fingerprint or fingerprints:

``` text
YOUR_DEBUG_SHA256_FINGERPRINT
YOUR_RELEASE_OR_PLAY_SHA256_FINGERPRINT
```

Do not publish or use an upload-key fingerprint in place of the Play App
Signing fingerprint when Google Play signs the app for distribution.

------------------------------------------------------------------------

# Step 5 --- Create Android's `assetlinks.json`

Create:

``` text
public/.well-known/assetlinks.json
```

Use this structure and replace the placeholders:

``` json
[
  {
    "relation": [
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "YOUR_ANDROID_APPLICATION_ID",
      "sha256_cert_fingerprints": [
        "YOUR_DEBUG_SHA256_FINGERPRINT",
        "YOUR_RELEASE_OR_PLAY_SHA256_FINGERPRINT"
      ]
    }
  }
]
```

**Explanation**

-   `relation` grants the app permission to handle links from the
    domain.
-   `namespace` identifies the target as an Android app.
-   `package_name` must exactly match the Android `applicationId`.
-   `sha256_cert_fingerprints` lists the signing certificate
    fingerprints Android should trust.
-   If you are only testing locally, you can initially include just the
    debug fingerprint.
-   For production, add the actual release/Play App Signing fingerprint.

If you have only one fingerprint, remove the unused placeholder and keep
a valid JSON array containing the one real fingerprint.

Example with one fingerprint:

``` json
[
  {
    "relation": [
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "com.yourcompany.chitchat",
      "sha256_cert_fingerprints": [
        "AA:BB:CC:DD:EE:FF:..."
      ]
    }
  }
]
```

The values in this second example are illustrative. Do not use them as
your real app credentials.

------------------------------------------------------------------------

# Step 6 --- Configure Android's manifest

Open:

``` text
android/app/src/main/AndroidManifest.xml
```

Find the `<activity>` for `.MainActivity`. Add an HTTPS intent filter
inside that activity.

Example:

``` xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">

    <!-- Existing Flutter launch intent filter stays here. -->

    <!-- Verified HTTPS links for Chit Chat. -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />

        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />

        <data
            android:scheme="https"
            android:host="rohan-shrestha.info.np"
            android:pathPrefix="/" />
    </intent-filter>

</activity>
```

**Explanation**

-   `VIEW` allows the activity to open a viewed URL.
-   `DEFAULT` and `BROWSABLE` allow links to be opened from other apps
    and browsers.
-   `android:autoVerify="true"` asks Android to verify the website
    association.
-   `scheme="https"` limits this filter to secure web links.
-   `host` must exactly match your domain.
-   `pathPrefix="/"` allows the app to receive paths under that domain.

**Important:** Merge this into your existing `MainActivity` declaration.
Do not replace the entire manifest with the example, because Flutter's
generated manifest contains other required configuration.

If you later decide to support a custom scheme too, add a separate
intent filter. It is optional and not required for HTTPS App Links.

Optional custom-scheme filter:

``` xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />

    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <data
        android:scheme="chitchat"
        android:host="" />
</intent-filter>
```

Custom-scheme matching can vary with URI parsing and platform
configuration. Test it separately; HTTPS links are the primary
implementation in this guide.

------------------------------------------------------------------------

# Step 7 --- Find the iOS Bundle ID and Apple Team ID

This step applies when you build and distribute the iOS app.

Open the iOS project in Xcode:

``` bash
open ios/Runner.xcworkspace
```

In Xcode:

1.  Select the `Runner` project.
2.  Select the `Runner` target.
3.  Open **Signing & Capabilities**.
4.  Find the **Bundle Identifier**.
5.  Find the selected **Team**.

Record:

``` text
YOUR_IOS_BUNDLE_ID
YOUR_APPLE_TEAM_ID
```

**Explanation**

-   The Bundle ID uniquely identifies the iOS app.
-   The Team ID identifies the Apple Developer team that signs it.
-   Apple combines these values to identify the app in the association
    file.

If you do not currently have access to a Mac or an Apple Developer
account, you can postpone the iOS steps. Android and iOS setup are
independent.

------------------------------------------------------------------------

# Step 8 --- Create Apple's `apple-app-site-association` file

Create this exact filename:

``` text
public/.well-known/apple-app-site-association
```

There is **no `.json` extension**.

Contents:

``` json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appIDs": [
          "YOUR_APPLE_TEAM_ID.YOUR_IOS_BUNDLE_ID"
        ],
        "components": [
          {
            "/": "/chats",
            "comment": "Open the Chit Chat conversations list"
          },
          {
            "/": "/chats/*",
            "comment": "Open a specific Chit Chat conversation"
          },
          {
            "/": "/friends",
            "comment": "Open the friends screen"
          },
          {
            "/": "/settings",
            "comment": "Open the settings screen"
          }
        ]
      }
    ]
  }
}
```

**Explanation**

-   `appIDs` contains the Team ID followed by a dot and the Bundle ID.
-   `components` lists the URL paths that should open the app.
-   `/chats/*` matches chat detail paths such as `/chats/101`.
-   Add or remove paths to match the routes you actually want to expose.

The file must be served directly over HTTPS from:

``` text
https://rohan-shrestha.info.np/.well-known/apple-app-site-association
```

The server should return a successful response and must not redirect the
request.

------------------------------------------------------------------------

# Step 9 --- Enable Associated Domains in Xcode

In Xcode:

1.  Open `ios/Runner.xcworkspace`.
2.  Select the `Runner` target.
3.  Open **Signing & Capabilities**.
4.  Add the **Associated Domains** capability.
5.  Add this entry:

``` text
applinks:rohan-shrestha.info.np
```

**Explanation**

The AASA file on your website declares which app is associated with the
domain. The Associated Domains entitlement on the app declares which
domain the app wants to associate with.

Both sides must agree. Adding only the website file is not enough.

------------------------------------------------------------------------

# Step 10 --- Let GoRouter handle the incoming route

GoRouter supports platform deep links. If the operating system launches
the Flutter app with a URL whose path matches a registered GoRouter
route, GoRouter can navigate to that route.

For the existing router, keep the deep-link paths aligned with your
route definitions:

``` dart
GoRoute(
  path: '/chats',
  name: 'chats',
  builder: (context, state) => const ChatsPage(),
  routes: [
    GoRoute(
      path: ':chatId',
      name: 'chatDetails',
      pageBuilder: (context, state) {
        final chatId = state.pathParameters['chatId']!;

        return RouteTransitions.slide(
          key: state.pageKey,
          child: ChatDetailsPage(chatId: chatId),
        );
      },
    ),
  ],
),
```

**Explanation**

-   The operating system opens the app with a URL.
-   Flutter receives the initial route or a later incoming route.
-   GoRouter matches the route path.
-   The `chatId` parameter is extracted and passed to the page.

You generally do not need to add another package just to receive
standard HTTPS links when using GoRouter's built-in deep-link support.

Do not create a second `GoRouter` instance for incoming links. Continue
using the single `AppRouter.router` instance already registered in the
app.

------------------------------------------------------------------------

# Step 11 --- Fix authentication redirects for deep links

This is especially important for Chit Chat because chat routes are
likely protected.

Imagine a user taps:

`https://rohan-shrestha.info.np/chats/101`

But they are not logged in.

Your current guard redirects unauthenticated users to `/login`. If the
original URL is discarded, the user may reach the chats list after login
rather than the intended conversation.

The redirect should preserve the intended destination.

A common pattern is to add the original location as a query parameter:

``` dart
static String? redirect(
  BuildContext context,
  GoRouterState state,
) {
  final location = state.matchedLocation;
  final isPublicRoute = _publicRoutes.contains(location);
  final isLoggingIn = location == AppRoutes.login.path;

  if (!isAuthenticated && !isPublicRoute) {
    final from = state.uri.toString();

    return Uri(
      path: AppRoutes.login.path,
      queryParameters: {'from': from},
    ).toString();
  }

  if (isAuthenticated && isLoggingIn) {
    final from = state.uri.queryParameters['from'];

    return from ?? AppRoutes.chats.path;
  }

  return null;
}
```

**Explanation**

-   `state.uri` contains the incoming location, including path
    parameters and query parameters.
-   When a user is not authenticated, the guard redirects to login and
    stores the original location in `from`.
-   After login, the guard reads `from` and sends the user to the
    requested destination.
-   If no `from` value exists, it sends the user to the Chats screen.

**Important implementation notes**

1.  Adapt this example to the exact signature and state access used by
    your current `RouteGuards` class.
2.  Make sure `/login` is actually registered before enabling this
    redirect.
3.  Keep `/splash` and `/login` public to avoid redirect loops.
4.  Validate the `from` destination before navigating to it. Only allow
    internal app paths that your app recognizes. Do not blindly navigate
    to arbitrary external URLs.
5.  Once authentication state changes, notify GoRouter through the
    existing `refreshListenable` mechanism so it reevaluates the
    redirect.

This step should be implemented and tested before relying on deep links
to protected screens.

------------------------------------------------------------------------

# Step 12 --- Test Android App Links

First deploy the association file and verify it is publicly accessible:

``` bash
curl -i https://rohan-shrestha.info.np/.well-known/assetlinks.json
```

Check that:

-   The response is successful.
-   The response body is valid JSON.
-   The package name is correct.
-   The SHA-256 fingerprint matches the certificate used to sign the
    installed app.
-   There is no redirect.

Install the Android app, then run:

``` bash
adb shell pm verify-app-links --re-verify YOUR_ANDROID_APPLICATION_ID
```

Check the verification state:

``` bash
adb shell pm get-app-links YOUR_ANDROID_APPLICATION_ID
```

Test opening a link:

``` bash
adb shell am start \
  -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://rohan-shrestha.info.np/chats/101"
```

**Explanation**

-   The first command checks that the website serves the file.
-   The verification command asks Android to re-check the domain
    association.
-   The status command shows the verification state.
-   The final command simulates tapping a link from another app.

If the app does not open, check the application ID, certificate
fingerprint, manifest host, website file URL, and Android verification
status.

------------------------------------------------------------------------

# Step 13 --- Test iOS Universal Links

After deploying the AASA file and enabling the Associated Domains
entitlement:

1.  Install the app on a real iOS device.
2.  Open a note or message containing a link such as
    `https://rohan-shrestha.info.np/chats/101`.
3.  Tap the link.
4.  Confirm that iOS opens Chit Chat and that GoRouter displays the
    matching conversation.

**Explanation**

Universal Links depend on the website association and the app
entitlement. Test on a real device with the correct signing
configuration. If the link opens Safari, check the AASA file, Team ID,
Bundle ID, Associated Domains entry, and deployment response.

------------------------------------------------------------------------

# Step 14 --- Add a website fallback later (optional)

If the app is not installed, the HTTPS link will open your website.

You can later add Next.js pages for paths such as:

``` text
/chats/101
/friends
/settings
```

Those pages can explain that the content is available in Chit Chat and
provide an app-store link when the app is published.

This is optional for the initial association setup. The association
files themselves do not create these fallback pages.

------------------------------------------------------------------------

# Part 3 --- Final checklist

Use this checklist when you are ready to implement:

-   [ ] Confirm the final Android `applicationId`.
-   [ ] Get the Android debug SHA-256 fingerprint.
-   [ ] Get the release / Play App Signing SHA-256 fingerprint before
    production.
-   [ ] Confirm the iOS Bundle ID.
-   [ ] Confirm the Apple Team ID.
-   [ ] Create `public/.well-known/` in the Next.js website.
-   [ ] Add `assetlinks.json`.
-   [ ] Add `apple-app-site-association` without a file extension.
-   [ ] Deploy the website.
-   [ ] Confirm both association URLs return successfully without
    redirects.
-   [ ] Add the HTTPS intent filter to Android's existing
    `MainActivity`.
-   [ ] Add the Associated Domains capability to iOS.
-   [ ] Confirm GoRouter has matching paths.
-   [ ] Register the login route before using the authentication
    redirect.
-   [ ] Preserve the original destination through login.
-   [ ] Test Android App Links.
-   [ ] Test iOS Universal Links.
-   [ ] Test links while logged out and while logged in.

------------------------------------------------------------------------

# Part 4 --- Complete code reference

This section gathers the important code snippets in one place. It is a
reference, not a set of files to paste blindly. Some snippets must be
merged into your existing project files, and platform-specific values
must be replaced.

## A. Android `assetlinks.json`

File:

`public/.well-known/assetlinks.json`

``` json
[
  {
    "relation": [
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "YOUR_ANDROID_APPLICATION_ID",
      "sha256_cert_fingerprints": [
        "YOUR_DEBUG_SHA256_FINGERPRINT",
        "YOUR_RELEASE_OR_PLAY_SHA256_FINGERPRINT"
      ]
    }
  }
]
```

## B. Apple `apple-app-site-association`

File:

`public/.well-known/apple-app-site-association`

``` json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appIDs": [
          "YOUR_APPLE_TEAM_ID.YOUR_IOS_BUNDLE_ID"
        ],
        "components": [
          {
            "/": "/chats"
          },
          {
            "/": "/chats/*"
          },
          {
            "/": "/friends"
          },
          {
            "/": "/settings"
          }
        ]
      }
    ]
  }
}
```

## C. Android manifest intent filter

Merge this inside the existing `.MainActivity` activity in:

`android/app/src/main/AndroidManifest.xml`

``` xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />

    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <data
        android:scheme="https"
        android:host="rohan-shrestha.info.np"
        android:pathPrefix="/" />
</intent-filter>
```

## D. GoRouter chat routes

Merge the following route structure into the existing Chats branch in
`app_router.dart`. Keep the existing navigation shell, navigator keys,
route guards, error builder, and transition helpers.

``` dart
GoRoute(
  path: AppRoutes.chats.path,
  name: AppRoutes.chats.name,
  builder: (context, state) {
    return const ChatsPage();
  },
  routes: [
    GoRoute(
      path: ':chatId',
      name: 'chatDetails',
      pageBuilder: (context, state) {
        final chatId = state.pathParameters['chatId']!;

        return RouteTransitions.slide(
          key: state.pageKey,
          child: ChatDetailsPage(chatId: chatId),
        );
      },
    ),
  ],
),
```

## E. Authentication redirect concept

Adapt this to your existing `RouteGuards` implementation. Ensure
`/login` exists before enabling it.

``` dart
static String? redirect(
  BuildContext context,
  GoRouterState state,
) {
  final location = state.matchedLocation;
  final isPublicRoute = _publicRoutes.contains(location);
  final isLoggingIn = location == AppRoutes.login.path;

  if (!isAuthenticated && !isPublicRoute) {
    final from = state.uri.toString();

    return Uri(
      path: AppRoutes.login.path,
      queryParameters: {'from': from},
    ).toString();
  }

  if (isAuthenticated && isLoggingIn) {
    final from = state.uri.queryParameters['from'];

    return from ?? AppRoutes.chats.path;
  }

  return null;
}
```

------------------------------------------------------------------------

# Part 5 --- Important notes

1.  **You do not need to implement this now.** This document is a saved
    implementation guide for when you are ready.
2.  **Do not use placeholder identifiers.** Android package ID, SHA-256
    fingerprints, iOS Bundle ID, and Apple Team ID must come from your
    actual app setup.
3.  **The website files alone are not enough.** Android and iOS also
    need their platform configuration.
4.  **The platform configuration alone is not enough.** GoRouter must
    have matching routes.
5.  **Authentication matters.** A link to a protected screen should take
    the user to login and then return them to the original destination.
6.  **Use HTTPS links for sharing.** Keep custom URL schemes optional
    unless you have a specific integration that needs them.
7.  **Do not create a second router.** Continue using the existing
    `AppRouter.router`.

## Official references

-   Android App Links: https://developer.android.com/training/app-links
-   Android asset statements:
    https://developer.android.com/training/app-links/configure-assetlinks
-   Apple Supporting Associated Domains:
    https://developer.apple.com/documentation/xcode/supporting-associated-domains
-   Apple Universal Links:
    https://developer.apple.com/ios/universal-links/
-   GoRouter package: https://pub.dev/packages/go_router
-   Next.js public folder:
    https://nextjs.org/docs/app/api-reference/file-conventions/public-folder
