# Ajilesh V — Personal Portfolio (Flutter)

A fully animated personal website built with **Flutter**, using **MVC
architecture** and **Provider** for state management. Runs on Web, and can
also be built for Android/iOS/Desktop since it's pure Flutter.

## ✨ Sections included
- Animated hero (typing-style rotating role titles, floating avatar, gradient text)
- About Me (from your CV summary)
- Skills (grouped cards: languages, frameworks, databases, tools, state
  management, etc.)
- Work Experience (animated timeline)
- Featured Projects (Quokart, DropBlood, Student Management x2, Netflix Clone)
- **Gallery** — a grid of your photos with a tap-to-zoom lightbox animation
  (currently sample placeholder images — swap them any time)
- Education & Certificates (Brototype, BCA, HSS, SSLC + Pentest/CEH certs)
- Contact cards (Email, Phone, LinkedIn, Instagram, GitHub) — tapping opens
  the right app (mailto / tel / browser)
- Animated, scroll-spy navbar (desktop) + slide-down mobile menu
- Scroll-reveal animations everywhere (fade + slide as you scroll), hover
  "lift & glow" on cards, pulsing "available" badge, floating avatar, etc.

## 🏗 Architecture (MVC + Provider)

```
lib/
├── models/            # M — plain data classes (ProfileModel, ProjectModel, ...)
├── controllers/        # C — ChangeNotifier Providers (state + actions)
│   ├── portfolio_provider.dart   # exposes profile/projects/skills/etc + link launching
│   ├── nav_provider.dart         # scroll position, active section, mobile menu
│   └── theme_provider.dart       # theme toggle (extendable)
├── views/               # V — screens & widgets (pure UI, reactive via Provider)
│   ├── home_view.dart
│   └── widgets/         # one file per section + shared animation widgets
├── utils/
│   ├── app_data.dart     # <-- ALL your CV content lives here, edit freely
│   ├── app_colors.dart
│   ├── app_theme.dart
│   └── responsive.dart
└── main.dart             # wires MultiProvider + MaterialApp
```

Views never read raw data directly — they always go through
`PortfolioProvider`, which pulls from `AppData` (in `utils/app_data.dart`).
That means:
- To edit your **text/links/CV content** → edit `lib/utils/app_data.dart` only.
- To edit **colors/fonts** → edit `lib/utils/app_colors.dart` / `app_theme.dart`.
- To add a **new section** → add a model (if needed), add data to
  `AppData`, create a widget in `lib/views/widgets/`, then add it to
  `lib/views/home_view.dart`.

## 🖼 Images — currently sample placeholders

This project ships with **auto-generated placeholder images** so it runs
immediately:
- `assets/images/profile.png` — your hero/profile avatar
- `assets/images/gallery_1.png` … `gallery_4.png` — the Gallery section

**To use your real photos:** just replace these files with your own images
using the **exact same filenames** (or update the paths in
`lib/utils/app_data.dart` under `profile: ProfileModel(...)`). No other code
changes are needed. Feel free to add more gallery images — just drop the
files into `assets/images/` and add their paths to the `galleryImages` list
in `app_data.dart`.

## ▶️ Getting started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) if
   you haven't already.
2. From this project folder, fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run it (pick a device):
   ```bash
   flutter run -d chrome     # Web (recommended for a personal website)
   flutter run -d macos      # or windows / linux / an emulator
   ```
4. Build a release web bundle to deploy (e.g. to GitHub Pages, Firebase
   Hosting, Netlify, Vercel):
   ```bash
   flutter build web
   # output in build/web — upload that folder to any static host
   ```

## 🔧 A couple of things worth double-checking
- `AppData.profile.githubUrl` in `lib/utils/app_data.dart` is currently a
  **placeholder** (`https://github.com/ajilesh46`) since your CV only shows
  the GitHub icon without a visible link — update it to your real profile
  URL, and update the per-project GitHub links (also placeholders) once you
  have the real repo URLs.
- Your LinkedIn and Instagram links from your message are already wired in
  and working.
- Contact form "mailto:" / "tel:" links open the user's default mail/phone
  app — this works out of the box on mobile/desktop; on web it depends on
  the browser having a handler configured.

## 📦 Packages used
| Package | Purpose |
|---|---|
| `provider` | State management (the "C" in MVC) |
| `animate_do` | Pre-built entrance animations (fade/slide) |
| `visibility_detector` | Scroll-reveal + navbar scroll-spy |
| `font_awesome_flutter` | Icons (skills, socials, links) |
| `url_launcher` | Opening email/phone/social links |
| `google_fonts` | Poppins typography |

Enjoy — and good luck with the launch! 🚀
"# Ajilesh_personal_profile" 
"# Ajilesh_personal_profile" 
"# Ajilesh_personal_profile" 
"# aji_profile_flutter" 
